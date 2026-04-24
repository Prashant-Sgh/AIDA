import 'package:aida/features/context/domain_layer/context_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contextCRUDProvider = Provider<ContextCRUD>(
  (ref) => ContextCRUD(),
);

class ContextCRUD {
  Future<void> create(ContextModel newContextModel) async {}
  Future<List<ContextModel>> fetchAll() async { return []; }
  Future<void> update(ContextModel contextModel) async {}
  Future<void> delete(ContextModel context) async {}
}