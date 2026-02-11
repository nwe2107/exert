import { readFileSync } from 'fs';
import { test, before, after } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';

const rules = readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8');

let env;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'exert-workout-rules',
    firestore: { rules },
  });
});

after(async () => {
  await env?.cleanup();
});

test('owner can create and read their profile doc', async () => {
  const owner = env.authenticatedContext('user_a', { email: 'a@example.com' });
  const db = owner.firestore();
  const docRef = db.collection('users').doc('user_a');

  await assertSucceeds(
    docRef.set({
      uid: 'user_a',
      email: 'a@example.com',
      displayName: 'User A',
      onboardingComplete: false,
    }),
  );
  await assertSucceeds(docRef.get());
});

test('owner can write nested session data', async () => {
  const owner = env.authenticatedContext('user_a');
  const db = owner.firestore();
  const sessionRef = db
    .collection('users')
    .doc('user_a')
    .collection('sessions')
    .doc('20260211');

  await assertSucceeds(
    sessionRef.set({
      id: 20260211,
      date: new Date().toISOString(),
    }),
  );
});

test('owner cannot read another user profile', async () => {
  const owner = env.authenticatedContext('user_a');
  const db = owner.firestore();

  await env.withSecurityRulesDisabled(async (context) => {
    await context.firestore().collection('users').doc('user_b').set({
      uid: 'user_b',
      email: 'b@example.com',
    });
  });

  await assertFails(db.collection('users').doc('user_b').get());
});

test('owner cannot write another user profile', async () => {
  const owner = env.authenticatedContext('user_a');
  const db = owner.firestore();
  await assertFails(
    db.collection('users').doc('user_b').set({'uid': 'user_b'}),
  );
});

test('unauthenticated clients cannot read profiles', async () => {
  const unauth = env.unauthenticatedContext();
  const db = unauth.firestore();

  await env.withSecurityRulesDisabled(async (context) => {
    await context.firestore().collection('users').doc('user_c').set({
      uid: 'user_c',
      email: 'c@example.com',
    });
  });

  await assertFails(db.collection('users').doc('user_c').get());
});
