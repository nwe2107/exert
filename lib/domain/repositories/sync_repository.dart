import 'dart:async';

enum SyncState { idle, syncing, conflict, error }

abstract class SyncRepository {
  Stream<SyncState> watchState();

  Future<void> pushLocalChanges();

  Future<void> pullRemoteChanges();

  Future<void> resolveConflicts();
}

class SyncCheckpoint {
  SyncCheckpoint({required this.lastSyncedAt});

  final DateTime? lastSyncedAt;
}
