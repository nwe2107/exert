import 'dart:async';

import '../../domain/repositories/sync_repository.dart';

/// Firestore sync scaffold for v2.
///
/// Notes for implementation phase:
/// - Keep Isar as source of truth.
/// - Add local change tracking (created/updated/deleted + version stamps).
/// - Implement pull-then-merge with deterministic conflict policy.
class FirestoreSyncRepository implements SyncRepository {
  FirestoreSyncRepository();

  final _controller = StreamController<SyncState>.broadcast();

  @override
  Stream<SyncState> watchState() {
    return _controller.stream;
  }

  @override
  Future<void> pullRemoteChanges() {
    throw UnimplementedError('Firestore pull sync is not implemented in v1.');
  }

  @override
  Future<void> pushLocalChanges() {
    throw UnimplementedError('Firestore push sync is not implemented in v1.');
  }

  @override
  Future<void> resolveConflicts() {
    throw UnimplementedError(
      'Conflict resolution workflow is not implemented in v1.',
    );
  }
}
