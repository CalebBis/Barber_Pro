import 'package:drift/drift.dart';

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text()();
  TextColumn get prenom => text()();
  TextColumn get telephone => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get totalCoupes => integer().withDefault(const Constant(0))();
  IntColumn get gratuitesDisponibles => integer().withDefault(const Constant(0))();
  DateTimeColumn get dateCreation => dateTime().withDefault(currentDateAndTime)();
}

class Coiffeurs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text()();
  TextColumn get prenom => text()();
  TextColumn get specialite => text().nullable()();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  
  // Nouveaux champs demandés
  TextColumn get photoPath => text().nullable()();
  TextColumn get nationalite => text().nullable()();
  TextColumn get lieuNaissance => text().nullable()();
  DateTimeColumn get dateNaissance => dateTime().nullable()();
  TextColumn get adresse => text().nullable()();
}

class Visites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer().references(Clients, #id)();
  IntColumn get coiffeurId => integer().references(Coiffeurs, #id)();
  DateTimeColumn get dateVisite => dateTime().withDefault(currentDateAndTime)();
  TextColumn get typeCoupe => text()(); // "classique" ou "premium"
  IntColumn get montant => integer()(); // 9000, 12000 ou 0
  BoolColumn get estGratuite => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
}

class Parametres extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get motDePasse => text().nullable()();
  TextColumn get nomSalon => text().withDefault(const Constant('Benji Coiffure'))();
  BoolColumn get themeClair => boolean().withDefault(const Constant(false))();
}
