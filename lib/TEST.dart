import 'dart:math';

import 'package:aida/features/context/data_layer/services/firestore_service.dart';
import 'package:aida/features/context/domain_layer/context_model.dart';

void main() async {
  print('it\'s working');
  final service = FirestoreServices();
  service.getContextById(id: '1778099438403');

  // final context = ContextModel(
  //     id: '1778349927744',
  //     name: 'Context 02 Updated',
  //     content: 'Updated context content');
  
  await service.deleteById(id: '1778099438403');
}
