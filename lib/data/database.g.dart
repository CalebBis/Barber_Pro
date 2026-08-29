// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
    'prenom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telephoneMeta = const VerificationMeta(
    'telephone',
  );
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
    'telephone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalCoupesMeta = const VerificationMeta(
    'totalCoupes',
  );
  @override
  late final GeneratedColumn<int> totalCoupes = GeneratedColumn<int>(
    'total_coupes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _gratuitesDisponiblesMeta =
      const VerificationMeta('gratuitesDisponibles');
  @override
  late final GeneratedColumn<int> gratuitesDisponibles = GeneratedColumn<int>(
    'gratuites_disponibles',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dateCreationMeta = const VerificationMeta(
    'dateCreation',
  );
  @override
  late final GeneratedColumn<DateTime> dateCreation = GeneratedColumn<DateTime>(
    'date_creation',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nom,
    prenom,
    telephone,
    notes,
    totalCoupes,
    gratuitesDisponibles,
    dateCreation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(
        _prenomMeta,
        prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta),
      );
    } else if (isInserting) {
      context.missing(_prenomMeta);
    }
    if (data.containsKey('telephone')) {
      context.handle(
        _telephoneMeta,
        telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('total_coupes')) {
      context.handle(
        _totalCoupesMeta,
        totalCoupes.isAcceptableOrUnknown(
          data['total_coupes']!,
          _totalCoupesMeta,
        ),
      );
    }
    if (data.containsKey('gratuites_disponibles')) {
      context.handle(
        _gratuitesDisponiblesMeta,
        gratuitesDisponibles.isAcceptableOrUnknown(
          data['gratuites_disponibles']!,
          _gratuitesDisponiblesMeta,
        ),
      );
    }
    if (data.containsKey('date_creation')) {
      context.handle(
        _dateCreationMeta,
        dateCreation.isAcceptableOrUnknown(
          data['date_creation']!,
          _dateCreationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      prenom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prenom'],
      )!,
      telephone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telephone'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      totalCoupes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_coupes'],
      )!,
      gratuitesDisponibles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gratuites_disponibles'],
      )!,
      dateCreation: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_creation'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final int id;
  final String nom;
  final String prenom;
  final String? telephone;
  final String? notes;
  final int totalCoupes;
  final int gratuitesDisponibles;
  final DateTime dateCreation;
  const Client({
    required this.id,
    required this.nom,
    required this.prenom,
    this.telephone,
    this.notes,
    required this.totalCoupes,
    required this.gratuitesDisponibles,
    required this.dateCreation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom'] = Variable<String>(nom);
    map['prenom'] = Variable<String>(prenom);
    if (!nullToAbsent || telephone != null) {
      map['telephone'] = Variable<String>(telephone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['total_coupes'] = Variable<int>(totalCoupes);
    map['gratuites_disponibles'] = Variable<int>(gratuitesDisponibles);
    map['date_creation'] = Variable<DateTime>(dateCreation);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      nom: Value(nom),
      prenom: Value(prenom),
      telephone: telephone == null && nullToAbsent
          ? const Value.absent()
          : Value(telephone),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      totalCoupes: Value(totalCoupes),
      gratuitesDisponibles: Value(gratuitesDisponibles),
      dateCreation: Value(dateCreation),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<int>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      prenom: serializer.fromJson<String>(json['prenom']),
      telephone: serializer.fromJson<String?>(json['telephone']),
      notes: serializer.fromJson<String?>(json['notes']),
      totalCoupes: serializer.fromJson<int>(json['totalCoupes']),
      gratuitesDisponibles: serializer.fromJson<int>(
        json['gratuitesDisponibles'],
      ),
      dateCreation: serializer.fromJson<DateTime>(json['dateCreation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nom': serializer.toJson<String>(nom),
      'prenom': serializer.toJson<String>(prenom),
      'telephone': serializer.toJson<String?>(telephone),
      'notes': serializer.toJson<String?>(notes),
      'totalCoupes': serializer.toJson<int>(totalCoupes),
      'gratuitesDisponibles': serializer.toJson<int>(gratuitesDisponibles),
      'dateCreation': serializer.toJson<DateTime>(dateCreation),
    };
  }

  Client copyWith({
    int? id,
    String? nom,
    String? prenom,
    Value<String?> telephone = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? totalCoupes,
    int? gratuitesDisponibles,
    DateTime? dateCreation,
  }) => Client(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    prenom: prenom ?? this.prenom,
    telephone: telephone.present ? telephone.value : this.telephone,
    notes: notes.present ? notes.value : this.notes,
    totalCoupes: totalCoupes ?? this.totalCoupes,
    gratuitesDisponibles: gratuitesDisponibles ?? this.gratuitesDisponibles,
    dateCreation: dateCreation ?? this.dateCreation,
  );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      prenom: data.prenom.present ? data.prenom.value : this.prenom,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      notes: data.notes.present ? data.notes.value : this.notes,
      totalCoupes: data.totalCoupes.present
          ? data.totalCoupes.value
          : this.totalCoupes,
      gratuitesDisponibles: data.gratuitesDisponibles.present
          ? data.gratuitesDisponibles.value
          : this.gratuitesDisponibles,
      dateCreation: data.dateCreation.present
          ? data.dateCreation.value
          : this.dateCreation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('telephone: $telephone, ')
          ..write('notes: $notes, ')
          ..write('totalCoupes: $totalCoupes, ')
          ..write('gratuitesDisponibles: $gratuitesDisponibles, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nom,
    prenom,
    telephone,
    notes,
    totalCoupes,
    gratuitesDisponibles,
    dateCreation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.prenom == this.prenom &&
          other.telephone == this.telephone &&
          other.notes == this.notes &&
          other.totalCoupes == this.totalCoupes &&
          other.gratuitesDisponibles == this.gratuitesDisponibles &&
          other.dateCreation == this.dateCreation);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<int> id;
  final Value<String> nom;
  final Value<String> prenom;
  final Value<String?> telephone;
  final Value<String?> notes;
  final Value<int> totalCoupes;
  final Value<int> gratuitesDisponibles;
  final Value<DateTime> dateCreation;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.prenom = const Value.absent(),
    this.telephone = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalCoupes = const Value.absent(),
    this.gratuitesDisponibles = const Value.absent(),
    this.dateCreation = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String nom,
    required String prenom,
    this.telephone = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalCoupes = const Value.absent(),
    this.gratuitesDisponibles = const Value.absent(),
    this.dateCreation = const Value.absent(),
  }) : nom = Value(nom),
       prenom = Value(prenom);
  static Insertable<Client> custom({
    Expression<int>? id,
    Expression<String>? nom,
    Expression<String>? prenom,
    Expression<String>? telephone,
    Expression<String>? notes,
    Expression<int>? totalCoupes,
    Expression<int>? gratuitesDisponibles,
    Expression<DateTime>? dateCreation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (telephone != null) 'telephone': telephone,
      if (notes != null) 'notes': notes,
      if (totalCoupes != null) 'total_coupes': totalCoupes,
      if (gratuitesDisponibles != null)
        'gratuites_disponibles': gratuitesDisponibles,
      if (dateCreation != null) 'date_creation': dateCreation,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? id,
    Value<String>? nom,
    Value<String>? prenom,
    Value<String?>? telephone,
    Value<String?>? notes,
    Value<int>? totalCoupes,
    Value<int>? gratuitesDisponibles,
    Value<DateTime>? dateCreation,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      notes: notes ?? this.notes,
      totalCoupes: totalCoupes ?? this.totalCoupes,
      gratuitesDisponibles: gratuitesDisponibles ?? this.gratuitesDisponibles,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (totalCoupes.present) {
      map['total_coupes'] = Variable<int>(totalCoupes.value);
    }
    if (gratuitesDisponibles.present) {
      map['gratuites_disponibles'] = Variable<int>(gratuitesDisponibles.value);
    }
    if (dateCreation.present) {
      map['date_creation'] = Variable<DateTime>(dateCreation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('telephone: $telephone, ')
          ..write('notes: $notes, ')
          ..write('totalCoupes: $totalCoupes, ')
          ..write('gratuitesDisponibles: $gratuitesDisponibles, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }
}

class $CoiffeursTable extends Coiffeurs
    with TableInfo<$CoiffeursTable, Coiffeur> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoiffeursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
    'prenom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specialiteMeta = const VerificationMeta(
    'specialite',
  );
  @override
  late final GeneratedColumn<String> specialite = GeneratedColumn<String>(
    'specialite',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actifMeta = const VerificationMeta('actif');
  @override
  late final GeneratedColumn<bool> actif = GeneratedColumn<bool>(
    'actif',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("actif" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nationaliteMeta = const VerificationMeta(
    'nationalite',
  );
  @override
  late final GeneratedColumn<String> nationalite = GeneratedColumn<String>(
    'nationalite',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lieuNaissanceMeta = const VerificationMeta(
    'lieuNaissance',
  );
  @override
  late final GeneratedColumn<String> lieuNaissance = GeneratedColumn<String>(
    'lieu_naissance',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateNaissanceMeta = const VerificationMeta(
    'dateNaissance',
  );
  @override
  late final GeneratedColumn<DateTime> dateNaissance =
      GeneratedColumn<DateTime>(
        'date_naissance',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _adresseMeta = const VerificationMeta(
    'adresse',
  );
  @override
  late final GeneratedColumn<String> adresse = GeneratedColumn<String>(
    'adresse',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telephoneMeta = const VerificationMeta(
    'telephone',
  );
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
    'telephone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nom,
    prenom,
    specialite,
    actif,
    photoPath,
    nationalite,
    lieuNaissance,
    dateNaissance,
    adresse,
    telephone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coiffeurs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Coiffeur> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(
        _prenomMeta,
        prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta),
      );
    } else if (isInserting) {
      context.missing(_prenomMeta);
    }
    if (data.containsKey('specialite')) {
      context.handle(
        _specialiteMeta,
        specialite.isAcceptableOrUnknown(data['specialite']!, _specialiteMeta),
      );
    }
    if (data.containsKey('actif')) {
      context.handle(
        _actifMeta,
        actif.isAcceptableOrUnknown(data['actif']!, _actifMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('nationalite')) {
      context.handle(
        _nationaliteMeta,
        nationalite.isAcceptableOrUnknown(
          data['nationalite']!,
          _nationaliteMeta,
        ),
      );
    }
    if (data.containsKey('lieu_naissance')) {
      context.handle(
        _lieuNaissanceMeta,
        lieuNaissance.isAcceptableOrUnknown(
          data['lieu_naissance']!,
          _lieuNaissanceMeta,
        ),
      );
    }
    if (data.containsKey('date_naissance')) {
      context.handle(
        _dateNaissanceMeta,
        dateNaissance.isAcceptableOrUnknown(
          data['date_naissance']!,
          _dateNaissanceMeta,
        ),
      );
    }
    if (data.containsKey('adresse')) {
      context.handle(
        _adresseMeta,
        adresse.isAcceptableOrUnknown(data['adresse']!, _adresseMeta),
      );
    }
    if (data.containsKey('telephone')) {
      context.handle(
        _telephoneMeta,
        telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Coiffeur map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Coiffeur(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      prenom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prenom'],
      )!,
      specialite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialite'],
      ),
      actif: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}actif'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      nationalite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nationalite'],
      ),
      lieuNaissance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lieu_naissance'],
      ),
      dateNaissance: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_naissance'],
      ),
      adresse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adresse'],
      ),
      telephone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telephone'],
      ),
    );
  }

  @override
  $CoiffeursTable createAlias(String alias) {
    return $CoiffeursTable(attachedDatabase, alias);
  }
}

class Coiffeur extends DataClass implements Insertable<Coiffeur> {
  final int id;
  final String nom;
  final String prenom;
  final String? specialite;
  final bool actif;
  final String? photoPath;
  final String? nationalite;
  final String? lieuNaissance;
  final DateTime? dateNaissance;
  final String? adresse;
  final String? telephone;
  const Coiffeur({
    required this.id,
    required this.nom,
    required this.prenom,
    this.specialite,
    required this.actif,
    this.photoPath,
    this.nationalite,
    this.lieuNaissance,
    this.dateNaissance,
    this.adresse,
    this.telephone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom'] = Variable<String>(nom);
    map['prenom'] = Variable<String>(prenom);
    if (!nullToAbsent || specialite != null) {
      map['specialite'] = Variable<String>(specialite);
    }
    map['actif'] = Variable<bool>(actif);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || nationalite != null) {
      map['nationalite'] = Variable<String>(nationalite);
    }
    if (!nullToAbsent || lieuNaissance != null) {
      map['lieu_naissance'] = Variable<String>(lieuNaissance);
    }
    if (!nullToAbsent || dateNaissance != null) {
      map['date_naissance'] = Variable<DateTime>(dateNaissance);
    }
    if (!nullToAbsent || adresse != null) {
      map['adresse'] = Variable<String>(adresse);
    }
    if (!nullToAbsent || telephone != null) {
      map['telephone'] = Variable<String>(telephone);
    }
    return map;
  }

  CoiffeursCompanion toCompanion(bool nullToAbsent) {
    return CoiffeursCompanion(
      id: Value(id),
      nom: Value(nom),
      prenom: Value(prenom),
      specialite: specialite == null && nullToAbsent
          ? const Value.absent()
          : Value(specialite),
      actif: Value(actif),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      nationalite: nationalite == null && nullToAbsent
          ? const Value.absent()
          : Value(nationalite),
      lieuNaissance: lieuNaissance == null && nullToAbsent
          ? const Value.absent()
          : Value(lieuNaissance),
      dateNaissance: dateNaissance == null && nullToAbsent
          ? const Value.absent()
          : Value(dateNaissance),
      adresse: adresse == null && nullToAbsent
          ? const Value.absent()
          : Value(adresse),
      telephone: telephone == null && nullToAbsent
          ? const Value.absent()
          : Value(telephone),
    );
  }

  factory Coiffeur.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Coiffeur(
      id: serializer.fromJson<int>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      prenom: serializer.fromJson<String>(json['prenom']),
      specialite: serializer.fromJson<String?>(json['specialite']),
      actif: serializer.fromJson<bool>(json['actif']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      nationalite: serializer.fromJson<String?>(json['nationalite']),
      lieuNaissance: serializer.fromJson<String?>(json['lieuNaissance']),
      dateNaissance: serializer.fromJson<DateTime?>(json['dateNaissance']),
      adresse: serializer.fromJson<String?>(json['adresse']),
      telephone: serializer.fromJson<String?>(json['telephone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nom': serializer.toJson<String>(nom),
      'prenom': serializer.toJson<String>(prenom),
      'specialite': serializer.toJson<String?>(specialite),
      'actif': serializer.toJson<bool>(actif),
      'photoPath': serializer.toJson<String?>(photoPath),
      'nationalite': serializer.toJson<String?>(nationalite),
      'lieuNaissance': serializer.toJson<String?>(lieuNaissance),
      'dateNaissance': serializer.toJson<DateTime?>(dateNaissance),
      'adresse': serializer.toJson<String?>(adresse),
      'telephone': serializer.toJson<String?>(telephone),
    };
  }

  Coiffeur copyWith({
    int? id,
    String? nom,
    String? prenom,
    Value<String?> specialite = const Value.absent(),
    bool? actif,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> nationalite = const Value.absent(),
    Value<String?> lieuNaissance = const Value.absent(),
    Value<DateTime?> dateNaissance = const Value.absent(),
    Value<String?> adresse = const Value.absent(),
    Value<String?> telephone = const Value.absent(),
  }) => Coiffeur(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    prenom: prenom ?? this.prenom,
    specialite: specialite.present ? specialite.value : this.specialite,
    actif: actif ?? this.actif,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    nationalite: nationalite.present ? nationalite.value : this.nationalite,
    lieuNaissance: lieuNaissance.present
        ? lieuNaissance.value
        : this.lieuNaissance,
    dateNaissance: dateNaissance.present
        ? dateNaissance.value
        : this.dateNaissance,
    adresse: adresse.present ? adresse.value : this.adresse,
    telephone: telephone.present ? telephone.value : this.telephone,
  );
  Coiffeur copyWithCompanion(CoiffeursCompanion data) {
    return Coiffeur(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      prenom: data.prenom.present ? data.prenom.value : this.prenom,
      specialite: data.specialite.present
          ? data.specialite.value
          : this.specialite,
      actif: data.actif.present ? data.actif.value : this.actif,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      nationalite: data.nationalite.present
          ? data.nationalite.value
          : this.nationalite,
      lieuNaissance: data.lieuNaissance.present
          ? data.lieuNaissance.value
          : this.lieuNaissance,
      dateNaissance: data.dateNaissance.present
          ? data.dateNaissance.value
          : this.dateNaissance,
      adresse: data.adresse.present ? data.adresse.value : this.adresse,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Coiffeur(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('specialite: $specialite, ')
          ..write('actif: $actif, ')
          ..write('photoPath: $photoPath, ')
          ..write('nationalite: $nationalite, ')
          ..write('lieuNaissance: $lieuNaissance, ')
          ..write('dateNaissance: $dateNaissance, ')
          ..write('adresse: $adresse, ')
          ..write('telephone: $telephone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nom,
    prenom,
    specialite,
    actif,
    photoPath,
    nationalite,
    lieuNaissance,
    dateNaissance,
    adresse,
    telephone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coiffeur &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.prenom == this.prenom &&
          other.specialite == this.specialite &&
          other.actif == this.actif &&
          other.photoPath == this.photoPath &&
          other.nationalite == this.nationalite &&
          other.lieuNaissance == this.lieuNaissance &&
          other.dateNaissance == this.dateNaissance &&
          other.adresse == this.adresse &&
          other.telephone == this.telephone);
}

class CoiffeursCompanion extends UpdateCompanion<Coiffeur> {
  final Value<int> id;
  final Value<String> nom;
  final Value<String> prenom;
  final Value<String?> specialite;
  final Value<bool> actif;
  final Value<String?> photoPath;
  final Value<String?> nationalite;
  final Value<String?> lieuNaissance;
  final Value<DateTime?> dateNaissance;
  final Value<String?> adresse;
  final Value<String?> telephone;
  const CoiffeursCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.prenom = const Value.absent(),
    this.specialite = const Value.absent(),
    this.actif = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.nationalite = const Value.absent(),
    this.lieuNaissance = const Value.absent(),
    this.dateNaissance = const Value.absent(),
    this.adresse = const Value.absent(),
    this.telephone = const Value.absent(),
  });
  CoiffeursCompanion.insert({
    this.id = const Value.absent(),
    required String nom,
    required String prenom,
    this.specialite = const Value.absent(),
    this.actif = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.nationalite = const Value.absent(),
    this.lieuNaissance = const Value.absent(),
    this.dateNaissance = const Value.absent(),
    this.adresse = const Value.absent(),
    this.telephone = const Value.absent(),
  }) : nom = Value(nom),
       prenom = Value(prenom);
  static Insertable<Coiffeur> custom({
    Expression<int>? id,
    Expression<String>? nom,
    Expression<String>? prenom,
    Expression<String>? specialite,
    Expression<bool>? actif,
    Expression<String>? photoPath,
    Expression<String>? nationalite,
    Expression<String>? lieuNaissance,
    Expression<DateTime>? dateNaissance,
    Expression<String>? adresse,
    Expression<String>? telephone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (specialite != null) 'specialite': specialite,
      if (actif != null) 'actif': actif,
      if (photoPath != null) 'photo_path': photoPath,
      if (nationalite != null) 'nationalite': nationalite,
      if (lieuNaissance != null) 'lieu_naissance': lieuNaissance,
      if (dateNaissance != null) 'date_naissance': dateNaissance,
      if (adresse != null) 'adresse': adresse,
      if (telephone != null) 'telephone': telephone,
    });
  }

  CoiffeursCompanion copyWith({
    Value<int>? id,
    Value<String>? nom,
    Value<String>? prenom,
    Value<String?>? specialite,
    Value<bool>? actif,
    Value<String?>? photoPath,
    Value<String?>? nationalite,
    Value<String?>? lieuNaissance,
    Value<DateTime?>? dateNaissance,
    Value<String?>? adresse,
    Value<String?>? telephone,
  }) {
    return CoiffeursCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      specialite: specialite ?? this.specialite,
      actif: actif ?? this.actif,
      photoPath: photoPath ?? this.photoPath,
      nationalite: nationalite ?? this.nationalite,
      lieuNaissance: lieuNaissance ?? this.lieuNaissance,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      adresse: adresse ?? this.adresse,
      telephone: telephone ?? this.telephone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (specialite.present) {
      map['specialite'] = Variable<String>(specialite.value);
    }
    if (actif.present) {
      map['actif'] = Variable<bool>(actif.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (nationalite.present) {
      map['nationalite'] = Variable<String>(nationalite.value);
    }
    if (lieuNaissance.present) {
      map['lieu_naissance'] = Variable<String>(lieuNaissance.value);
    }
    if (dateNaissance.present) {
      map['date_naissance'] = Variable<DateTime>(dateNaissance.value);
    }
    if (adresse.present) {
      map['adresse'] = Variable<String>(adresse.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoiffeursCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('specialite: $specialite, ')
          ..write('actif: $actif, ')
          ..write('photoPath: $photoPath, ')
          ..write('nationalite: $nationalite, ')
          ..write('lieuNaissance: $lieuNaissance, ')
          ..write('dateNaissance: $dateNaissance, ')
          ..write('adresse: $adresse, ')
          ..write('telephone: $telephone')
          ..write(')'))
        .toString();
  }
}

class $VisitesTable extends Visites with TableInfo<$VisitesTable, Visite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _coiffeurIdMeta = const VerificationMeta(
    'coiffeurId',
  );
  @override
  late final GeneratedColumn<int> coiffeurId = GeneratedColumn<int>(
    'coiffeur_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES coiffeurs (id)',
    ),
  );
  static const VerificationMeta _dateVisiteMeta = const VerificationMeta(
    'dateVisite',
  );
  @override
  late final GeneratedColumn<DateTime> dateVisite = GeneratedColumn<DateTime>(
    'date_visite',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _typeCoupeMeta = const VerificationMeta(
    'typeCoupe',
  );
  @override
  late final GeneratedColumn<String> typeCoupe = GeneratedColumn<String>(
    'type_coupe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montantMeta = const VerificationMeta(
    'montant',
  );
  @override
  late final GeneratedColumn<int> montant = GeneratedColumn<int>(
    'montant',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estGratuiteMeta = const VerificationMeta(
    'estGratuite',
  );
  @override
  late final GeneratedColumn<bool> estGratuite = GeneratedColumn<bool>(
    'est_gratuite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("est_gratuite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    coiffeurId,
    dateVisite,
    typeCoupe,
    montant,
    estGratuite,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Visite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('coiffeur_id')) {
      context.handle(
        _coiffeurIdMeta,
        coiffeurId.isAcceptableOrUnknown(data['coiffeur_id']!, _coiffeurIdMeta),
      );
    } else if (isInserting) {
      context.missing(_coiffeurIdMeta);
    }
    if (data.containsKey('date_visite')) {
      context.handle(
        _dateVisiteMeta,
        dateVisite.isAcceptableOrUnknown(data['date_visite']!, _dateVisiteMeta),
      );
    }
    if (data.containsKey('type_coupe')) {
      context.handle(
        _typeCoupeMeta,
        typeCoupe.isAcceptableOrUnknown(data['type_coupe']!, _typeCoupeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeCoupeMeta);
    }
    if (data.containsKey('montant')) {
      context.handle(
        _montantMeta,
        montant.isAcceptableOrUnknown(data['montant']!, _montantMeta),
      );
    } else if (isInserting) {
      context.missing(_montantMeta);
    }
    if (data.containsKey('est_gratuite')) {
      context.handle(
        _estGratuiteMeta,
        estGratuite.isAcceptableOrUnknown(
          data['est_gratuite']!,
          _estGratuiteMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Visite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Visite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      coiffeurId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coiffeur_id'],
      )!,
      dateVisite: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_visite'],
      )!,
      typeCoupe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_coupe'],
      )!,
      montant: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}montant'],
      )!,
      estGratuite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}est_gratuite'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $VisitesTable createAlias(String alias) {
    return $VisitesTable(attachedDatabase, alias);
  }
}

class Visite extends DataClass implements Insertable<Visite> {
  final int id;
  final int clientId;
  final int coiffeurId;
  final DateTime dateVisite;
  final String typeCoupe;
  final int montant;
  final bool estGratuite;
  final String? note;
  const Visite({
    required this.id,
    required this.clientId,
    required this.coiffeurId,
    required this.dateVisite,
    required this.typeCoupe,
    required this.montant,
    required this.estGratuite,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<int>(clientId);
    map['coiffeur_id'] = Variable<int>(coiffeurId);
    map['date_visite'] = Variable<DateTime>(dateVisite);
    map['type_coupe'] = Variable<String>(typeCoupe);
    map['montant'] = Variable<int>(montant);
    map['est_gratuite'] = Variable<bool>(estGratuite);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  VisitesCompanion toCompanion(bool nullToAbsent) {
    return VisitesCompanion(
      id: Value(id),
      clientId: Value(clientId),
      coiffeurId: Value(coiffeurId),
      dateVisite: Value(dateVisite),
      typeCoupe: Value(typeCoupe),
      montant: Value(montant),
      estGratuite: Value(estGratuite),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Visite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Visite(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int>(json['clientId']),
      coiffeurId: serializer.fromJson<int>(json['coiffeurId']),
      dateVisite: serializer.fromJson<DateTime>(json['dateVisite']),
      typeCoupe: serializer.fromJson<String>(json['typeCoupe']),
      montant: serializer.fromJson<int>(json['montant']),
      estGratuite: serializer.fromJson<bool>(json['estGratuite']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'coiffeurId': serializer.toJson<int>(coiffeurId),
      'dateVisite': serializer.toJson<DateTime>(dateVisite),
      'typeCoupe': serializer.toJson<String>(typeCoupe),
      'montant': serializer.toJson<int>(montant),
      'estGratuite': serializer.toJson<bool>(estGratuite),
      'note': serializer.toJson<String?>(note),
    };
  }

  Visite copyWith({
    int? id,
    int? clientId,
    int? coiffeurId,
    DateTime? dateVisite,
    String? typeCoupe,
    int? montant,
    bool? estGratuite,
    Value<String?> note = const Value.absent(),
  }) => Visite(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    coiffeurId: coiffeurId ?? this.coiffeurId,
    dateVisite: dateVisite ?? this.dateVisite,
    typeCoupe: typeCoupe ?? this.typeCoupe,
    montant: montant ?? this.montant,
    estGratuite: estGratuite ?? this.estGratuite,
    note: note.present ? note.value : this.note,
  );
  Visite copyWithCompanion(VisitesCompanion data) {
    return Visite(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      coiffeurId: data.coiffeurId.present
          ? data.coiffeurId.value
          : this.coiffeurId,
      dateVisite: data.dateVisite.present
          ? data.dateVisite.value
          : this.dateVisite,
      typeCoupe: data.typeCoupe.present ? data.typeCoupe.value : this.typeCoupe,
      montant: data.montant.present ? data.montant.value : this.montant,
      estGratuite: data.estGratuite.present
          ? data.estGratuite.value
          : this.estGratuite,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Visite(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('coiffeurId: $coiffeurId, ')
          ..write('dateVisite: $dateVisite, ')
          ..write('typeCoupe: $typeCoupe, ')
          ..write('montant: $montant, ')
          ..write('estGratuite: $estGratuite, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    coiffeurId,
    dateVisite,
    typeCoupe,
    montant,
    estGratuite,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Visite &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.coiffeurId == this.coiffeurId &&
          other.dateVisite == this.dateVisite &&
          other.typeCoupe == this.typeCoupe &&
          other.montant == this.montant &&
          other.estGratuite == this.estGratuite &&
          other.note == this.note);
}

class VisitesCompanion extends UpdateCompanion<Visite> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<int> coiffeurId;
  final Value<DateTime> dateVisite;
  final Value<String> typeCoupe;
  final Value<int> montant;
  final Value<bool> estGratuite;
  final Value<String?> note;
  const VisitesCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.coiffeurId = const Value.absent(),
    this.dateVisite = const Value.absent(),
    this.typeCoupe = const Value.absent(),
    this.montant = const Value.absent(),
    this.estGratuite = const Value.absent(),
    this.note = const Value.absent(),
  });
  VisitesCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    required int coiffeurId,
    this.dateVisite = const Value.absent(),
    required String typeCoupe,
    required int montant,
    this.estGratuite = const Value.absent(),
    this.note = const Value.absent(),
  }) : clientId = Value(clientId),
       coiffeurId = Value(coiffeurId),
       typeCoupe = Value(typeCoupe),
       montant = Value(montant);
  static Insertable<Visite> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<int>? coiffeurId,
    Expression<DateTime>? dateVisite,
    Expression<String>? typeCoupe,
    Expression<int>? montant,
    Expression<bool>? estGratuite,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (coiffeurId != null) 'coiffeur_id': coiffeurId,
      if (dateVisite != null) 'date_visite': dateVisite,
      if (typeCoupe != null) 'type_coupe': typeCoupe,
      if (montant != null) 'montant': montant,
      if (estGratuite != null) 'est_gratuite': estGratuite,
      if (note != null) 'note': note,
    });
  }

  VisitesCompanion copyWith({
    Value<int>? id,
    Value<int>? clientId,
    Value<int>? coiffeurId,
    Value<DateTime>? dateVisite,
    Value<String>? typeCoupe,
    Value<int>? montant,
    Value<bool>? estGratuite,
    Value<String?>? note,
  }) {
    return VisitesCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      coiffeurId: coiffeurId ?? this.coiffeurId,
      dateVisite: dateVisite ?? this.dateVisite,
      typeCoupe: typeCoupe ?? this.typeCoupe,
      montant: montant ?? this.montant,
      estGratuite: estGratuite ?? this.estGratuite,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (coiffeurId.present) {
      map['coiffeur_id'] = Variable<int>(coiffeurId.value);
    }
    if (dateVisite.present) {
      map['date_visite'] = Variable<DateTime>(dateVisite.value);
    }
    if (typeCoupe.present) {
      map['type_coupe'] = Variable<String>(typeCoupe.value);
    }
    if (montant.present) {
      map['montant'] = Variable<int>(montant.value);
    }
    if (estGratuite.present) {
      map['est_gratuite'] = Variable<bool>(estGratuite.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitesCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('coiffeurId: $coiffeurId, ')
          ..write('dateVisite: $dateVisite, ')
          ..write('typeCoupe: $typeCoupe, ')
          ..write('montant: $montant, ')
          ..write('estGratuite: $estGratuite, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ParametresTable extends Parametres
    with TableInfo<$ParametresTable, Parametre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParametresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _motDePasseMeta = const VerificationMeta(
    'motDePasse',
  );
  @override
  late final GeneratedColumn<String> motDePasse = GeneratedColumn<String>(
    'mot_de_passe',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nomSalonMeta = const VerificationMeta(
    'nomSalon',
  );
  @override
  late final GeneratedColumn<String> nomSalon = GeneratedColumn<String>(
    'nom_salon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Benji Coiffure'),
  );
  static const VerificationMeta _themeClairMeta = const VerificationMeta(
    'themeClair',
  );
  @override
  late final GeneratedColumn<bool> themeClair = GeneratedColumn<bool>(
    'theme_clair',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("theme_clair" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, motDePasse, nomSalon, themeClair];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parametres';
  @override
  VerificationContext validateIntegrity(
    Insertable<Parametre> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mot_de_passe')) {
      context.handle(
        _motDePasseMeta,
        motDePasse.isAcceptableOrUnknown(
          data['mot_de_passe']!,
          _motDePasseMeta,
        ),
      );
    }
    if (data.containsKey('nom_salon')) {
      context.handle(
        _nomSalonMeta,
        nomSalon.isAcceptableOrUnknown(data['nom_salon']!, _nomSalonMeta),
      );
    }
    if (data.containsKey('theme_clair')) {
      context.handle(
        _themeClairMeta,
        themeClair.isAcceptableOrUnknown(data['theme_clair']!, _themeClairMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Parametre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Parametre(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      motDePasse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mot_de_passe'],
      ),
      nomSalon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom_salon'],
      )!,
      themeClair: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}theme_clair'],
      )!,
    );
  }

  @override
  $ParametresTable createAlias(String alias) {
    return $ParametresTable(attachedDatabase, alias);
  }
}

class Parametre extends DataClass implements Insertable<Parametre> {
  final int id;
  final String? motDePasse;
  final String nomSalon;
  final bool themeClair;
  const Parametre({
    required this.id,
    this.motDePasse,
    required this.nomSalon,
    required this.themeClair,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || motDePasse != null) {
      map['mot_de_passe'] = Variable<String>(motDePasse);
    }
    map['nom_salon'] = Variable<String>(nomSalon);
    map['theme_clair'] = Variable<bool>(themeClair);
    return map;
  }

  ParametresCompanion toCompanion(bool nullToAbsent) {
    return ParametresCompanion(
      id: Value(id),
      motDePasse: motDePasse == null && nullToAbsent
          ? const Value.absent()
          : Value(motDePasse),
      nomSalon: Value(nomSalon),
      themeClair: Value(themeClair),
    );
  }

  factory Parametre.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Parametre(
      id: serializer.fromJson<int>(json['id']),
      motDePasse: serializer.fromJson<String?>(json['motDePasse']),
      nomSalon: serializer.fromJson<String>(json['nomSalon']),
      themeClair: serializer.fromJson<bool>(json['themeClair']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'motDePasse': serializer.toJson<String?>(motDePasse),
      'nomSalon': serializer.toJson<String>(nomSalon),
      'themeClair': serializer.toJson<bool>(themeClair),
    };
  }

  Parametre copyWith({
    int? id,
    Value<String?> motDePasse = const Value.absent(),
    String? nomSalon,
    bool? themeClair,
  }) => Parametre(
    id: id ?? this.id,
    motDePasse: motDePasse.present ? motDePasse.value : this.motDePasse,
    nomSalon: nomSalon ?? this.nomSalon,
    themeClair: themeClair ?? this.themeClair,
  );
  Parametre copyWithCompanion(ParametresCompanion data) {
    return Parametre(
      id: data.id.present ? data.id.value : this.id,
      motDePasse: data.motDePasse.present
          ? data.motDePasse.value
          : this.motDePasse,
      nomSalon: data.nomSalon.present ? data.nomSalon.value : this.nomSalon,
      themeClair: data.themeClair.present
          ? data.themeClair.value
          : this.themeClair,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Parametre(')
          ..write('id: $id, ')
          ..write('motDePasse: $motDePasse, ')
          ..write('nomSalon: $nomSalon, ')
          ..write('themeClair: $themeClair')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, motDePasse, nomSalon, themeClair);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parametre &&
          other.id == this.id &&
          other.motDePasse == this.motDePasse &&
          other.nomSalon == this.nomSalon &&
          other.themeClair == this.themeClair);
}

class ParametresCompanion extends UpdateCompanion<Parametre> {
  final Value<int> id;
  final Value<String?> motDePasse;
  final Value<String> nomSalon;
  final Value<bool> themeClair;
  const ParametresCompanion({
    this.id = const Value.absent(),
    this.motDePasse = const Value.absent(),
    this.nomSalon = const Value.absent(),
    this.themeClair = const Value.absent(),
  });
  ParametresCompanion.insert({
    this.id = const Value.absent(),
    this.motDePasse = const Value.absent(),
    this.nomSalon = const Value.absent(),
    this.themeClair = const Value.absent(),
  });
  static Insertable<Parametre> custom({
    Expression<int>? id,
    Expression<String>? motDePasse,
    Expression<String>? nomSalon,
    Expression<bool>? themeClair,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (motDePasse != null) 'mot_de_passe': motDePasse,
      if (nomSalon != null) 'nom_salon': nomSalon,
      if (themeClair != null) 'theme_clair': themeClair,
    });
  }

  ParametresCompanion copyWith({
    Value<int>? id,
    Value<String?>? motDePasse,
    Value<String>? nomSalon,
    Value<bool>? themeClair,
  }) {
    return ParametresCompanion(
      id: id ?? this.id,
      motDePasse: motDePasse ?? this.motDePasse,
      nomSalon: nomSalon ?? this.nomSalon,
      themeClair: themeClair ?? this.themeClair,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (motDePasse.present) {
      map['mot_de_passe'] = Variable<String>(motDePasse.value);
    }
    if (nomSalon.present) {
      map['nom_salon'] = Variable<String>(nomSalon.value);
    }
    if (themeClair.present) {
      map['theme_clair'] = Variable<bool>(themeClair.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParametresCompanion(')
          ..write('id: $id, ')
          ..write('motDePasse: $motDePasse, ')
          ..write('nomSalon: $nomSalon, ')
          ..write('themeClair: $themeClair')
          ..write(')'))
        .toString();
  }
}

class $RendezVousTable extends RendezVous
    with TableInfo<$RendezVousTable, RendezVousData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RendezVousTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _coiffeurIdMeta = const VerificationMeta(
    'coiffeurId',
  );
  @override
  late final GeneratedColumn<int> coiffeurId = GeneratedColumn<int>(
    'coiffeur_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES coiffeurs (id)',
    ),
  );
  static const VerificationMeta _dateRdvMeta = const VerificationMeta(
    'dateRdv',
  );
  @override
  late final GeneratedColumn<DateTime> dateRdv = GeneratedColumn<DateTime>(
    'date_rdv',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeCoupeMeta = const VerificationMeta(
    'typeCoupe',
  );
  @override
  late final GeneratedColumn<String> typeCoupe = GeneratedColumn<String>(
    'type_coupe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
    'statut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en_attente'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateCreationMeta = const VerificationMeta(
    'dateCreation',
  );
  @override
  late final GeneratedColumn<DateTime> dateCreation = GeneratedColumn<DateTime>(
    'date_creation',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    coiffeurId,
    dateRdv,
    typeCoupe,
    statut,
    note,
    dateCreation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rendez_vous';
  @override
  VerificationContext validateIntegrity(
    Insertable<RendezVousData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('coiffeur_id')) {
      context.handle(
        _coiffeurIdMeta,
        coiffeurId.isAcceptableOrUnknown(data['coiffeur_id']!, _coiffeurIdMeta),
      );
    } else if (isInserting) {
      context.missing(_coiffeurIdMeta);
    }
    if (data.containsKey('date_rdv')) {
      context.handle(
        _dateRdvMeta,
        dateRdv.isAcceptableOrUnknown(data['date_rdv']!, _dateRdvMeta),
      );
    } else if (isInserting) {
      context.missing(_dateRdvMeta);
    }
    if (data.containsKey('type_coupe')) {
      context.handle(
        _typeCoupeMeta,
        typeCoupe.isAcceptableOrUnknown(data['type_coupe']!, _typeCoupeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeCoupeMeta);
    }
    if (data.containsKey('statut')) {
      context.handle(
        _statutMeta,
        statut.isAcceptableOrUnknown(data['statut']!, _statutMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date_creation')) {
      context.handle(
        _dateCreationMeta,
        dateCreation.isAcceptableOrUnknown(
          data['date_creation']!,
          _dateCreationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RendezVousData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RendezVousData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      coiffeurId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coiffeur_id'],
      )!,
      dateRdv: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_rdv'],
      )!,
      typeCoupe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_coupe'],
      )!,
      statut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      dateCreation: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_creation'],
      )!,
    );
  }

  @override
  $RendezVousTable createAlias(String alias) {
    return $RendezVousTable(attachedDatabase, alias);
  }
}

class RendezVousData extends DataClass implements Insertable<RendezVousData> {
  final int id;
  final int clientId;
  final int coiffeurId;
  final DateTime dateRdv;
  final String typeCoupe;
  final String statut;
  final String? note;
  final DateTime dateCreation;
  const RendezVousData({
    required this.id,
    required this.clientId,
    required this.coiffeurId,
    required this.dateRdv,
    required this.typeCoupe,
    required this.statut,
    this.note,
    required this.dateCreation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<int>(clientId);
    map['coiffeur_id'] = Variable<int>(coiffeurId);
    map['date_rdv'] = Variable<DateTime>(dateRdv);
    map['type_coupe'] = Variable<String>(typeCoupe);
    map['statut'] = Variable<String>(statut);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date_creation'] = Variable<DateTime>(dateCreation);
    return map;
  }

  RendezVousCompanion toCompanion(bool nullToAbsent) {
    return RendezVousCompanion(
      id: Value(id),
      clientId: Value(clientId),
      coiffeurId: Value(coiffeurId),
      dateRdv: Value(dateRdv),
      typeCoupe: Value(typeCoupe),
      statut: Value(statut),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      dateCreation: Value(dateCreation),
    );
  }

  factory RendezVousData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RendezVousData(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int>(json['clientId']),
      coiffeurId: serializer.fromJson<int>(json['coiffeurId']),
      dateRdv: serializer.fromJson<DateTime>(json['dateRdv']),
      typeCoupe: serializer.fromJson<String>(json['typeCoupe']),
      statut: serializer.fromJson<String>(json['statut']),
      note: serializer.fromJson<String?>(json['note']),
      dateCreation: serializer.fromJson<DateTime>(json['dateCreation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'coiffeurId': serializer.toJson<int>(coiffeurId),
      'dateRdv': serializer.toJson<DateTime>(dateRdv),
      'typeCoupe': serializer.toJson<String>(typeCoupe),
      'statut': serializer.toJson<String>(statut),
      'note': serializer.toJson<String?>(note),
      'dateCreation': serializer.toJson<DateTime>(dateCreation),
    };
  }

  RendezVousData copyWith({
    int? id,
    int? clientId,
    int? coiffeurId,
    DateTime? dateRdv,
    String? typeCoupe,
    String? statut,
    Value<String?> note = const Value.absent(),
    DateTime? dateCreation,
  }) => RendezVousData(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    coiffeurId: coiffeurId ?? this.coiffeurId,
    dateRdv: dateRdv ?? this.dateRdv,
    typeCoupe: typeCoupe ?? this.typeCoupe,
    statut: statut ?? this.statut,
    note: note.present ? note.value : this.note,
    dateCreation: dateCreation ?? this.dateCreation,
  );
  RendezVousData copyWithCompanion(RendezVousCompanion data) {
    return RendezVousData(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      coiffeurId: data.coiffeurId.present
          ? data.coiffeurId.value
          : this.coiffeurId,
      dateRdv: data.dateRdv.present ? data.dateRdv.value : this.dateRdv,
      typeCoupe: data.typeCoupe.present ? data.typeCoupe.value : this.typeCoupe,
      statut: data.statut.present ? data.statut.value : this.statut,
      note: data.note.present ? data.note.value : this.note,
      dateCreation: data.dateCreation.present
          ? data.dateCreation.value
          : this.dateCreation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RendezVousData(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('coiffeurId: $coiffeurId, ')
          ..write('dateRdv: $dateRdv, ')
          ..write('typeCoupe: $typeCoupe, ')
          ..write('statut: $statut, ')
          ..write('note: $note, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    coiffeurId,
    dateRdv,
    typeCoupe,
    statut,
    note,
    dateCreation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RendezVousData &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.coiffeurId == this.coiffeurId &&
          other.dateRdv == this.dateRdv &&
          other.typeCoupe == this.typeCoupe &&
          other.statut == this.statut &&
          other.note == this.note &&
          other.dateCreation == this.dateCreation);
}

class RendezVousCompanion extends UpdateCompanion<RendezVousData> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<int> coiffeurId;
  final Value<DateTime> dateRdv;
  final Value<String> typeCoupe;
  final Value<String> statut;
  final Value<String?> note;
  final Value<DateTime> dateCreation;
  const RendezVousCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.coiffeurId = const Value.absent(),
    this.dateRdv = const Value.absent(),
    this.typeCoupe = const Value.absent(),
    this.statut = const Value.absent(),
    this.note = const Value.absent(),
    this.dateCreation = const Value.absent(),
  });
  RendezVousCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    required int coiffeurId,
    required DateTime dateRdv,
    required String typeCoupe,
    this.statut = const Value.absent(),
    this.note = const Value.absent(),
    this.dateCreation = const Value.absent(),
  }) : clientId = Value(clientId),
       coiffeurId = Value(coiffeurId),
       dateRdv = Value(dateRdv),
       typeCoupe = Value(typeCoupe);
  static Insertable<RendezVousData> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<int>? coiffeurId,
    Expression<DateTime>? dateRdv,
    Expression<String>? typeCoupe,
    Expression<String>? statut,
    Expression<String>? note,
    Expression<DateTime>? dateCreation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (coiffeurId != null) 'coiffeur_id': coiffeurId,
      if (dateRdv != null) 'date_rdv': dateRdv,
      if (typeCoupe != null) 'type_coupe': typeCoupe,
      if (statut != null) 'statut': statut,
      if (note != null) 'note': note,
      if (dateCreation != null) 'date_creation': dateCreation,
    });
  }

  RendezVousCompanion copyWith({
    Value<int>? id,
    Value<int>? clientId,
    Value<int>? coiffeurId,
    Value<DateTime>? dateRdv,
    Value<String>? typeCoupe,
    Value<String>? statut,
    Value<String?>? note,
    Value<DateTime>? dateCreation,
  }) {
    return RendezVousCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      coiffeurId: coiffeurId ?? this.coiffeurId,
      dateRdv: dateRdv ?? this.dateRdv,
      typeCoupe: typeCoupe ?? this.typeCoupe,
      statut: statut ?? this.statut,
      note: note ?? this.note,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (coiffeurId.present) {
      map['coiffeur_id'] = Variable<int>(coiffeurId.value);
    }
    if (dateRdv.present) {
      map['date_rdv'] = Variable<DateTime>(dateRdv.value);
    }
    if (typeCoupe.present) {
      map['type_coupe'] = Variable<String>(typeCoupe.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (dateCreation.present) {
      map['date_creation'] = Variable<DateTime>(dateCreation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RendezVousCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('coiffeurId: $coiffeurId, ')
          ..write('dateRdv: $dateRdv, ')
          ..write('typeCoupe: $typeCoupe, ')
          ..write('statut: $statut, ')
          ..write('note: $note, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $CoiffeursTable coiffeurs = $CoiffeursTable(this);
  late final $VisitesTable visites = $VisitesTable(this);
  late final $ParametresTable parametres = $ParametresTable(this);
  late final $RendezVousTable rendezVous = $RendezVousTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clients,
    coiffeurs,
    visites,
    parametres,
    rendezVous,
  ];
}

typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      required String nom,
      required String prenom,
      Value<String?> telephone,
      Value<String?> notes,
      Value<int> totalCoupes,
      Value<int> gratuitesDisponibles,
      Value<DateTime> dateCreation,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      Value<String> nom,
      Value<String> prenom,
      Value<String?> telephone,
      Value<String?> notes,
      Value<int> totalCoupes,
      Value<int> gratuitesDisponibles,
      Value<DateTime> dateCreation,
    });

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, Client> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VisitesTable, List<Visite>> _visitesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.visites,
    aliasName: $_aliasNameGenerator(db.clients.id, db.visites.clientId),
  );

  $$VisitesTableProcessedTableManager get visitesRefs {
    final manager = $$VisitesTableTableManager(
      $_db,
      $_db.visites,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RendezVousTable, List<RendezVousData>>
  _rendezVousRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rendezVous,
    aliasName: $_aliasNameGenerator(db.clients.id, db.rendezVous.clientId),
  );

  $$RendezVousTableProcessedTableManager get rendezVousRefs {
    final manager = $$RendezVousTableTableManager(
      $_db,
      $_db.rendezVous,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rendezVousRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCoupes => $composableBuilder(
    column: $table.totalCoupes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gratuitesDisponibles => $composableBuilder(
    column: $table.gratuitesDisponibles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateCreation => $composableBuilder(
    column: $table.dateCreation,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> visitesRefs(
    Expression<bool> Function($$VisitesTableFilterComposer f) f,
  ) {
    final $$VisitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visites,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitesTableFilterComposer(
            $db: $db,
            $table: $db.visites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rendezVousRefs(
    Expression<bool> Function($$RendezVousTableFilterComposer f) f,
  ) {
    final $$RendezVousTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rendezVous,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RendezVousTableFilterComposer(
            $db: $db,
            $table: $db.rendezVous,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCoupes => $composableBuilder(
    column: $table.totalCoupes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gratuitesDisponibles => $composableBuilder(
    column: $table.gratuitesDisponibles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateCreation => $composableBuilder(
    column: $table.dateCreation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get totalCoupes => $composableBuilder(
    column: $table.totalCoupes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gratuitesDisponibles => $composableBuilder(
    column: $table.gratuitesDisponibles,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateCreation => $composableBuilder(
    column: $table.dateCreation,
    builder: (column) => column,
  );

  Expression<T> visitesRefs<T extends Object>(
    Expression<T> Function($$VisitesTableAnnotationComposer a) f,
  ) {
    final $$VisitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visites,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitesTableAnnotationComposer(
            $db: $db,
            $table: $db.visites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rendezVousRefs<T extends Object>(
    Expression<T> Function($$RendezVousTableAnnotationComposer a) f,
  ) {
    final $$RendezVousTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rendezVous,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RendezVousTableAnnotationComposer(
            $db: $db,
            $table: $db.rendezVous,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, $$ClientsTableReferences),
          Client,
          PrefetchHooks Function({bool visitesRefs, bool rendezVousRefs})
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String> prenom = const Value.absent(),
                Value<String?> telephone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> totalCoupes = const Value.absent(),
                Value<int> gratuitesDisponibles = const Value.absent(),
                Value<DateTime> dateCreation = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                nom: nom,
                prenom: prenom,
                telephone: telephone,
                notes: notes,
                totalCoupes: totalCoupes,
                gratuitesDisponibles: gratuitesDisponibles,
                dateCreation: dateCreation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nom,
                required String prenom,
                Value<String?> telephone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> totalCoupes = const Value.absent(),
                Value<int> gratuitesDisponibles = const Value.absent(),
                Value<DateTime> dateCreation = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                nom: nom,
                prenom: prenom,
                telephone: telephone,
                notes: notes,
                totalCoupes: totalCoupes,
                gratuitesDisponibles: gratuitesDisponibles,
                dateCreation: dateCreation,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({visitesRefs = false, rendezVousRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (visitesRefs) db.visites,
                    if (rendezVousRefs) db.rendezVous,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (visitesRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          Visite
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._visitesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).visitesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rendezVousRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          RendezVousData
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._rendezVousRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).rendezVousRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, $$ClientsTableReferences),
      Client,
      PrefetchHooks Function({bool visitesRefs, bool rendezVousRefs})
    >;
typedef $$CoiffeursTableCreateCompanionBuilder =
    CoiffeursCompanion Function({
      Value<int> id,
      required String nom,
      required String prenom,
      Value<String?> specialite,
      Value<bool> actif,
      Value<String?> photoPath,
      Value<String?> nationalite,
      Value<String?> lieuNaissance,
      Value<DateTime?> dateNaissance,
      Value<String?> adresse,
      Value<String?> telephone,
    });
typedef $$CoiffeursTableUpdateCompanionBuilder =
    CoiffeursCompanion Function({
      Value<int> id,
      Value<String> nom,
      Value<String> prenom,
      Value<String?> specialite,
      Value<bool> actif,
      Value<String?> photoPath,
      Value<String?> nationalite,
      Value<String?> lieuNaissance,
      Value<DateTime?> dateNaissance,
      Value<String?> adresse,
      Value<String?> telephone,
    });

final class $$CoiffeursTableReferences
    extends BaseReferences<_$AppDatabase, $CoiffeursTable, Coiffeur> {
  $$CoiffeursTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VisitesTable, List<Visite>> _visitesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.visites,
    aliasName: $_aliasNameGenerator(db.coiffeurs.id, db.visites.coiffeurId),
  );

  $$VisitesTableProcessedTableManager get visitesRefs {
    final manager = $$VisitesTableTableManager(
      $_db,
      $_db.visites,
    ).filter((f) => f.coiffeurId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RendezVousTable, List<RendezVousData>>
  _rendezVousRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rendezVous,
    aliasName: $_aliasNameGenerator(db.coiffeurs.id, db.rendezVous.coiffeurId),
  );

  $$RendezVousTableProcessedTableManager get rendezVousRefs {
    final manager = $$RendezVousTableTableManager(
      $_db,
      $_db.rendezVous,
    ).filter((f) => f.coiffeurId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rendezVousRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CoiffeursTableFilterComposer
    extends Composer<_$AppDatabase, $CoiffeursTable> {
  $$CoiffeursTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialite => $composableBuilder(
    column: $table.specialite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get actif => $composableBuilder(
    column: $table.actif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationalite => $composableBuilder(
    column: $table.nationalite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lieuNaissance => $composableBuilder(
    column: $table.lieuNaissance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adresse => $composableBuilder(
    column: $table.adresse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> visitesRefs(
    Expression<bool> Function($$VisitesTableFilterComposer f) f,
  ) {
    final $$VisitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visites,
      getReferencedColumn: (t) => t.coiffeurId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitesTableFilterComposer(
            $db: $db,
            $table: $db.visites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rendezVousRefs(
    Expression<bool> Function($$RendezVousTableFilterComposer f) f,
  ) {
    final $$RendezVousTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rendezVous,
      getReferencedColumn: (t) => t.coiffeurId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RendezVousTableFilterComposer(
            $db: $db,
            $table: $db.rendezVous,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoiffeursTableOrderingComposer
    extends Composer<_$AppDatabase, $CoiffeursTable> {
  $$CoiffeursTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialite => $composableBuilder(
    column: $table.specialite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get actif => $composableBuilder(
    column: $table.actif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationalite => $composableBuilder(
    column: $table.nationalite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lieuNaissance => $composableBuilder(
    column: $table.lieuNaissance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adresse => $composableBuilder(
    column: $table.adresse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoiffeursTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoiffeursTable> {
  $$CoiffeursTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<String> get specialite => $composableBuilder(
    column: $table.specialite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get actif =>
      $composableBuilder(column: $table.actif, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get nationalite => $composableBuilder(
    column: $table.nationalite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lieuNaissance => $composableBuilder(
    column: $table.lieuNaissance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateNaissance => $composableBuilder(
    column: $table.dateNaissance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get adresse =>
      $composableBuilder(column: $table.adresse, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  Expression<T> visitesRefs<T extends Object>(
    Expression<T> Function($$VisitesTableAnnotationComposer a) f,
  ) {
    final $$VisitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visites,
      getReferencedColumn: (t) => t.coiffeurId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitesTableAnnotationComposer(
            $db: $db,
            $table: $db.visites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rendezVousRefs<T extends Object>(
    Expression<T> Function($$RendezVousTableAnnotationComposer a) f,
  ) {
    final $$RendezVousTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rendezVous,
      getReferencedColumn: (t) => t.coiffeurId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RendezVousTableAnnotationComposer(
            $db: $db,
            $table: $db.rendezVous,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoiffeursTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoiffeursTable,
          Coiffeur,
          $$CoiffeursTableFilterComposer,
          $$CoiffeursTableOrderingComposer,
          $$CoiffeursTableAnnotationComposer,
          $$CoiffeursTableCreateCompanionBuilder,
          $$CoiffeursTableUpdateCompanionBuilder,
          (Coiffeur, $$CoiffeursTableReferences),
          Coiffeur,
          PrefetchHooks Function({bool visitesRefs, bool rendezVousRefs})
        > {
  $$CoiffeursTableTableManager(_$AppDatabase db, $CoiffeursTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoiffeursTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoiffeursTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoiffeursTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String> prenom = const Value.absent(),
                Value<String?> specialite = const Value.absent(),
                Value<bool> actif = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> nationalite = const Value.absent(),
                Value<String?> lieuNaissance = const Value.absent(),
                Value<DateTime?> dateNaissance = const Value.absent(),
                Value<String?> adresse = const Value.absent(),
                Value<String?> telephone = const Value.absent(),
              }) => CoiffeursCompanion(
                id: id,
                nom: nom,
                prenom: prenom,
                specialite: specialite,
                actif: actif,
                photoPath: photoPath,
                nationalite: nationalite,
                lieuNaissance: lieuNaissance,
                dateNaissance: dateNaissance,
                adresse: adresse,
                telephone: telephone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nom,
                required String prenom,
                Value<String?> specialite = const Value.absent(),
                Value<bool> actif = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> nationalite = const Value.absent(),
                Value<String?> lieuNaissance = const Value.absent(),
                Value<DateTime?> dateNaissance = const Value.absent(),
                Value<String?> adresse = const Value.absent(),
                Value<String?> telephone = const Value.absent(),
              }) => CoiffeursCompanion.insert(
                id: id,
                nom: nom,
                prenom: prenom,
                specialite: specialite,
                actif: actif,
                photoPath: photoPath,
                nationalite: nationalite,
                lieuNaissance: lieuNaissance,
                dateNaissance: dateNaissance,
                adresse: adresse,
                telephone: telephone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CoiffeursTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({visitesRefs = false, rendezVousRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (visitesRefs) db.visites,
                    if (rendezVousRefs) db.rendezVous,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (visitesRefs)
                        await $_getPrefetchedData<
                          Coiffeur,
                          $CoiffeursTable,
                          Visite
                        >(
                          currentTable: table,
                          referencedTable: $$CoiffeursTableReferences
                              ._visitesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CoiffeursTableReferences(
                                db,
                                table,
                                p0,
                              ).visitesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.coiffeurId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rendezVousRefs)
                        await $_getPrefetchedData<
                          Coiffeur,
                          $CoiffeursTable,
                          RendezVousData
                        >(
                          currentTable: table,
                          referencedTable: $$CoiffeursTableReferences
                              ._rendezVousRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CoiffeursTableReferences(
                                db,
                                table,
                                p0,
                              ).rendezVousRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.coiffeurId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CoiffeursTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoiffeursTable,
      Coiffeur,
      $$CoiffeursTableFilterComposer,
      $$CoiffeursTableOrderingComposer,
      $$CoiffeursTableAnnotationComposer,
      $$CoiffeursTableCreateCompanionBuilder,
      $$CoiffeursTableUpdateCompanionBuilder,
      (Coiffeur, $$CoiffeursTableReferences),
      Coiffeur,
      PrefetchHooks Function({bool visitesRefs, bool rendezVousRefs})
    >;
typedef $$VisitesTableCreateCompanionBuilder =
    VisitesCompanion Function({
      Value<int> id,
      required int clientId,
      required int coiffeurId,
      Value<DateTime> dateVisite,
      required String typeCoupe,
      required int montant,
      Value<bool> estGratuite,
      Value<String?> note,
    });
typedef $$VisitesTableUpdateCompanionBuilder =
    VisitesCompanion Function({
      Value<int> id,
      Value<int> clientId,
      Value<int> coiffeurId,
      Value<DateTime> dateVisite,
      Value<String> typeCoupe,
      Value<int> montant,
      Value<bool> estGratuite,
      Value<String?> note,
    });

final class $$VisitesTableReferences
    extends BaseReferences<_$AppDatabase, $VisitesTable, Visite> {
  $$VisitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) => db.clients
      .createAlias($_aliasNameGenerator(db.visites.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CoiffeursTable _coiffeurIdTable(_$AppDatabase db) =>
      db.coiffeurs.createAlias(
        $_aliasNameGenerator(db.visites.coiffeurId, db.coiffeurs.id),
      );

  $$CoiffeursTableProcessedTableManager get coiffeurId {
    final $_column = $_itemColumn<int>('coiffeur_id')!;

    final manager = $$CoiffeursTableTableManager(
      $_db,
      $_db.coiffeurs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coiffeurIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VisitesTableFilterComposer
    extends Composer<_$AppDatabase, $VisitesTable> {
  $$VisitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateVisite => $composableBuilder(
    column: $table.dateVisite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeCoupe => $composableBuilder(
    column: $table.typeCoupe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montant => $composableBuilder(
    column: $table.montant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estGratuite => $composableBuilder(
    column: $table.estGratuite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoiffeursTableFilterComposer get coiffeurId {
    final $$CoiffeursTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coiffeurId,
      referencedTable: $db.coiffeurs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoiffeursTableFilterComposer(
            $db: $db,
            $table: $db.coiffeurs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitesTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitesTable> {
  $$VisitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateVisite => $composableBuilder(
    column: $table.dateVisite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeCoupe => $composableBuilder(
    column: $table.typeCoupe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montant => $composableBuilder(
    column: $table.montant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estGratuite => $composableBuilder(
    column: $table.estGratuite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoiffeursTableOrderingComposer get coiffeurId {
    final $$CoiffeursTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coiffeurId,
      referencedTable: $db.coiffeurs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoiffeursTableOrderingComposer(
            $db: $db,
            $table: $db.coiffeurs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitesTable> {
  $$VisitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dateVisite => $composableBuilder(
    column: $table.dateVisite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get typeCoupe =>
      $composableBuilder(column: $table.typeCoupe, builder: (column) => column);

  GeneratedColumn<int> get montant =>
      $composableBuilder(column: $table.montant, builder: (column) => column);

  GeneratedColumn<bool> get estGratuite => $composableBuilder(
    column: $table.estGratuite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoiffeursTableAnnotationComposer get coiffeurId {
    final $$CoiffeursTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coiffeurId,
      referencedTable: $db.coiffeurs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoiffeursTableAnnotationComposer(
            $db: $db,
            $table: $db.coiffeurs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitesTable,
          Visite,
          $$VisitesTableFilterComposer,
          $$VisitesTableOrderingComposer,
          $$VisitesTableAnnotationComposer,
          $$VisitesTableCreateCompanionBuilder,
          $$VisitesTableUpdateCompanionBuilder,
          (Visite, $$VisitesTableReferences),
          Visite,
          PrefetchHooks Function({bool clientId, bool coiffeurId})
        > {
  $$VisitesTableTableManager(_$AppDatabase db, $VisitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<int> coiffeurId = const Value.absent(),
                Value<DateTime> dateVisite = const Value.absent(),
                Value<String> typeCoupe = const Value.absent(),
                Value<int> montant = const Value.absent(),
                Value<bool> estGratuite = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => VisitesCompanion(
                id: id,
                clientId: clientId,
                coiffeurId: coiffeurId,
                dateVisite: dateVisite,
                typeCoupe: typeCoupe,
                montant: montant,
                estGratuite: estGratuite,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clientId,
                required int coiffeurId,
                Value<DateTime> dateVisite = const Value.absent(),
                required String typeCoupe,
                required int montant,
                Value<bool> estGratuite = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => VisitesCompanion.insert(
                id: id,
                clientId: clientId,
                coiffeurId: coiffeurId,
                dateVisite: dateVisite,
                typeCoupe: typeCoupe,
                montant: montant,
                estGratuite: estGratuite,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VisitesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false, coiffeurId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$VisitesTableReferences
                                    ._clientIdTable(db),
                                referencedColumn: $$VisitesTableReferences
                                    ._clientIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (coiffeurId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.coiffeurId,
                                referencedTable: $$VisitesTableReferences
                                    ._coiffeurIdTable(db),
                                referencedColumn: $$VisitesTableReferences
                                    ._coiffeurIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VisitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitesTable,
      Visite,
      $$VisitesTableFilterComposer,
      $$VisitesTableOrderingComposer,
      $$VisitesTableAnnotationComposer,
      $$VisitesTableCreateCompanionBuilder,
      $$VisitesTableUpdateCompanionBuilder,
      (Visite, $$VisitesTableReferences),
      Visite,
      PrefetchHooks Function({bool clientId, bool coiffeurId})
    >;
typedef $$ParametresTableCreateCompanionBuilder =
    ParametresCompanion Function({
      Value<int> id,
      Value<String?> motDePasse,
      Value<String> nomSalon,
      Value<bool> themeClair,
    });
typedef $$ParametresTableUpdateCompanionBuilder =
    ParametresCompanion Function({
      Value<int> id,
      Value<String?> motDePasse,
      Value<String> nomSalon,
      Value<bool> themeClair,
    });

class $$ParametresTableFilterComposer
    extends Composer<_$AppDatabase, $ParametresTable> {
  $$ParametresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motDePasse => $composableBuilder(
    column: $table.motDePasse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomSalon => $composableBuilder(
    column: $table.nomSalon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get themeClair => $composableBuilder(
    column: $table.themeClair,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParametresTableOrderingComposer
    extends Composer<_$AppDatabase, $ParametresTable> {
  $$ParametresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motDePasse => $composableBuilder(
    column: $table.motDePasse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomSalon => $composableBuilder(
    column: $table.nomSalon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get themeClair => $composableBuilder(
    column: $table.themeClair,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParametresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParametresTable> {
  $$ParametresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get motDePasse => $composableBuilder(
    column: $table.motDePasse,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nomSalon =>
      $composableBuilder(column: $table.nomSalon, builder: (column) => column);

  GeneratedColumn<bool> get themeClair => $composableBuilder(
    column: $table.themeClair,
    builder: (column) => column,
  );
}

class $$ParametresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParametresTable,
          Parametre,
          $$ParametresTableFilterComposer,
          $$ParametresTableOrderingComposer,
          $$ParametresTableAnnotationComposer,
          $$ParametresTableCreateCompanionBuilder,
          $$ParametresTableUpdateCompanionBuilder,
          (
            Parametre,
            BaseReferences<_$AppDatabase, $ParametresTable, Parametre>,
          ),
          Parametre,
          PrefetchHooks Function()
        > {
  $$ParametresTableTableManager(_$AppDatabase db, $ParametresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParametresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParametresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParametresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> motDePasse = const Value.absent(),
                Value<String> nomSalon = const Value.absent(),
                Value<bool> themeClair = const Value.absent(),
              }) => ParametresCompanion(
                id: id,
                motDePasse: motDePasse,
                nomSalon: nomSalon,
                themeClair: themeClair,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> motDePasse = const Value.absent(),
                Value<String> nomSalon = const Value.absent(),
                Value<bool> themeClair = const Value.absent(),
              }) => ParametresCompanion.insert(
                id: id,
                motDePasse: motDePasse,
                nomSalon: nomSalon,
                themeClair: themeClair,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParametresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParametresTable,
      Parametre,
      $$ParametresTableFilterComposer,
      $$ParametresTableOrderingComposer,
      $$ParametresTableAnnotationComposer,
      $$ParametresTableCreateCompanionBuilder,
      $$ParametresTableUpdateCompanionBuilder,
      (Parametre, BaseReferences<_$AppDatabase, $ParametresTable, Parametre>),
      Parametre,
      PrefetchHooks Function()
    >;
typedef $$RendezVousTableCreateCompanionBuilder =
    RendezVousCompanion Function({
      Value<int> id,
      required int clientId,
      required int coiffeurId,
      required DateTime dateRdv,
      required String typeCoupe,
      Value<String> statut,
      Value<String?> note,
      Value<DateTime> dateCreation,
    });
typedef $$RendezVousTableUpdateCompanionBuilder =
    RendezVousCompanion Function({
      Value<int> id,
      Value<int> clientId,
      Value<int> coiffeurId,
      Value<DateTime> dateRdv,
      Value<String> typeCoupe,
      Value<String> statut,
      Value<String?> note,
      Value<DateTime> dateCreation,
    });

final class $$RendezVousTableReferences
    extends BaseReferences<_$AppDatabase, $RendezVousTable, RendezVousData> {
  $$RendezVousTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) => db.clients
      .createAlias($_aliasNameGenerator(db.rendezVous.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CoiffeursTable _coiffeurIdTable(_$AppDatabase db) =>
      db.coiffeurs.createAlias(
        $_aliasNameGenerator(db.rendezVous.coiffeurId, db.coiffeurs.id),
      );

  $$CoiffeursTableProcessedTableManager get coiffeurId {
    final $_column = $_itemColumn<int>('coiffeur_id')!;

    final manager = $$CoiffeursTableTableManager(
      $_db,
      $_db.coiffeurs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coiffeurIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RendezVousTableFilterComposer
    extends Composer<_$AppDatabase, $RendezVousTable> {
  $$RendezVousTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateRdv => $composableBuilder(
    column: $table.dateRdv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeCoupe => $composableBuilder(
    column: $table.typeCoupe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateCreation => $composableBuilder(
    column: $table.dateCreation,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoiffeursTableFilterComposer get coiffeurId {
    final $$CoiffeursTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coiffeurId,
      referencedTable: $db.coiffeurs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoiffeursTableFilterComposer(
            $db: $db,
            $table: $db.coiffeurs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RendezVousTableOrderingComposer
    extends Composer<_$AppDatabase, $RendezVousTable> {
  $$RendezVousTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateRdv => $composableBuilder(
    column: $table.dateRdv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeCoupe => $composableBuilder(
    column: $table.typeCoupe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateCreation => $composableBuilder(
    column: $table.dateCreation,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoiffeursTableOrderingComposer get coiffeurId {
    final $$CoiffeursTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coiffeurId,
      referencedTable: $db.coiffeurs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoiffeursTableOrderingComposer(
            $db: $db,
            $table: $db.coiffeurs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RendezVousTableAnnotationComposer
    extends Composer<_$AppDatabase, $RendezVousTable> {
  $$RendezVousTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dateRdv =>
      $composableBuilder(column: $table.dateRdv, builder: (column) => column);

  GeneratedColumn<String> get typeCoupe =>
      $composableBuilder(column: $table.typeCoupe, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreation => $composableBuilder(
    column: $table.dateCreation,
    builder: (column) => column,
  );

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoiffeursTableAnnotationComposer get coiffeurId {
    final $$CoiffeursTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coiffeurId,
      referencedTable: $db.coiffeurs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoiffeursTableAnnotationComposer(
            $db: $db,
            $table: $db.coiffeurs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RendezVousTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RendezVousTable,
          RendezVousData,
          $$RendezVousTableFilterComposer,
          $$RendezVousTableOrderingComposer,
          $$RendezVousTableAnnotationComposer,
          $$RendezVousTableCreateCompanionBuilder,
          $$RendezVousTableUpdateCompanionBuilder,
          (RendezVousData, $$RendezVousTableReferences),
          RendezVousData,
          PrefetchHooks Function({bool clientId, bool coiffeurId})
        > {
  $$RendezVousTableTableManager(_$AppDatabase db, $RendezVousTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RendezVousTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RendezVousTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RendezVousTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<int> coiffeurId = const Value.absent(),
                Value<DateTime> dateRdv = const Value.absent(),
                Value<String> typeCoupe = const Value.absent(),
                Value<String> statut = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> dateCreation = const Value.absent(),
              }) => RendezVousCompanion(
                id: id,
                clientId: clientId,
                coiffeurId: coiffeurId,
                dateRdv: dateRdv,
                typeCoupe: typeCoupe,
                statut: statut,
                note: note,
                dateCreation: dateCreation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clientId,
                required int coiffeurId,
                required DateTime dateRdv,
                required String typeCoupe,
                Value<String> statut = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> dateCreation = const Value.absent(),
              }) => RendezVousCompanion.insert(
                id: id,
                clientId: clientId,
                coiffeurId: coiffeurId,
                dateRdv: dateRdv,
                typeCoupe: typeCoupe,
                statut: statut,
                note: note,
                dateCreation: dateCreation,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RendezVousTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false, coiffeurId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$RendezVousTableReferences
                                    ._clientIdTable(db),
                                referencedColumn: $$RendezVousTableReferences
                                    ._clientIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (coiffeurId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.coiffeurId,
                                referencedTable: $$RendezVousTableReferences
                                    ._coiffeurIdTable(db),
                                referencedColumn: $$RendezVousTableReferences
                                    ._coiffeurIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RendezVousTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RendezVousTable,
      RendezVousData,
      $$RendezVousTableFilterComposer,
      $$RendezVousTableOrderingComposer,
      $$RendezVousTableAnnotationComposer,
      $$RendezVousTableCreateCompanionBuilder,
      $$RendezVousTableUpdateCompanionBuilder,
      (RendezVousData, $$RendezVousTableReferences),
      RendezVousData,
      PrefetchHooks Function({bool clientId, bool coiffeurId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$CoiffeursTableTableManager get coiffeurs =>
      $$CoiffeursTableTableManager(_db, _db.coiffeurs);
  $$VisitesTableTableManager get visites =>
      $$VisitesTableTableManager(_db, _db.visites);
  $$ParametresTableTableManager get parametres =>
      $$ParametresTableTableManager(_db, _db.parametres);
  $$RendezVousTableTableManager get rendezVous =>
      $$RendezVousTableTableManager(_db, _db.rendezVous);
}
