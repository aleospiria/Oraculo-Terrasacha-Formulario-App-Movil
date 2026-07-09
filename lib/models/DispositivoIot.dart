/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the DispositivoIot type in your schema. */
class DispositivoIot extends amplify_core.Model {
  static const classType = const _DispositivoIotModelType();
  final String id;
  final String? _deviceId;
  final String? _nombre;
  final String? _departamento;
  final String? _zona;
  final TipoDispositivo? _tipoDispositivo;
  final String? _variablesPublicadas;
  final String? _localizacion;
  final EstadoDispositivo? _estado;
  final String? _observaciones;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final List<RelDispositivoGrupoIot>? _grupos;
  final List<MedicionIot>? _mediciones;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DispositivoIotModelIdentifier get modelIdentifier {
      return DispositivoIotModelIdentifier(
        id: id
      );
  }
  
  String get deviceId {
    try {
      return _deviceId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get nombre {
    try {
      return _nombre!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get departamento {
    try {
      return _departamento!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get zona {
    try {
      return _zona!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TipoDispositivo get tipoDispositivo {
    try {
      return _tipoDispositivo!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get variablesPublicadas {
    try {
      return _variablesPublicadas!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get localizacion {
    return _localizacion;
  }
  
  EstadoDispositivo get estado {
    try {
      return _estado!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get observaciones {
    return _observaciones;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  List<RelDispositivoGrupoIot>? get grupos {
    return _grupos;
  }
  
  List<MedicionIot>? get mediciones {
    return _mediciones;
  }
  
  const DispositivoIot._internal({required this.id, required deviceId, required nombre, required departamento, required zona, required tipoDispositivo, required variablesPublicadas, localizacion, required estado, observaciones, createdAt, updatedAt, grupos, mediciones}): _deviceId = deviceId, _nombre = nombre, _departamento = departamento, _zona = zona, _tipoDispositivo = tipoDispositivo, _variablesPublicadas = variablesPublicadas, _localizacion = localizacion, _estado = estado, _observaciones = observaciones, _createdAt = createdAt, _updatedAt = updatedAt, _grupos = grupos, _mediciones = mediciones;
  
  factory DispositivoIot({String? id, required String deviceId, required String nombre, required String departamento, required String zona, required TipoDispositivo tipoDispositivo, required String variablesPublicadas, String? localizacion, required EstadoDispositivo estado, String? observaciones, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, List<RelDispositivoGrupoIot>? grupos, List<MedicionIot>? mediciones}) {
    return DispositivoIot._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      deviceId: deviceId,
      nombre: nombre,
      departamento: departamento,
      zona: zona,
      tipoDispositivo: tipoDispositivo,
      variablesPublicadas: variablesPublicadas,
      localizacion: localizacion,
      estado: estado,
      observaciones: observaciones,
      createdAt: createdAt,
      updatedAt: updatedAt,
      grupos: grupos != null ? List<RelDispositivoGrupoIot>.unmodifiable(grupos) : grupos,
      mediciones: mediciones != null ? List<MedicionIot>.unmodifiable(mediciones) : mediciones);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DispositivoIot &&
      id == other.id &&
      _deviceId == other._deviceId &&
      _nombre == other._nombre &&
      _departamento == other._departamento &&
      _zona == other._zona &&
      _tipoDispositivo == other._tipoDispositivo &&
      _variablesPublicadas == other._variablesPublicadas &&
      _localizacion == other._localizacion &&
      _estado == other._estado &&
      _observaciones == other._observaciones &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt &&
      DeepCollectionEquality().equals(_grupos, other._grupos) &&
      DeepCollectionEquality().equals(_mediciones, other._mediciones);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("DispositivoIot {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("deviceId=" + "$_deviceId" + ", ");
    buffer.write("nombre=" + "$_nombre" + ", ");
    buffer.write("departamento=" + "$_departamento" + ", ");
    buffer.write("zona=" + "$_zona" + ", ");
    buffer.write("tipoDispositivo=" + (_tipoDispositivo != null ? amplify_core.enumToString(_tipoDispositivo)! : "null") + ", ");
    buffer.write("variablesPublicadas=" + "$_variablesPublicadas" + ", ");
    buffer.write("localizacion=" + "$_localizacion" + ", ");
    buffer.write("estado=" + (_estado != null ? amplify_core.enumToString(_estado)! : "null") + ", ");
    buffer.write("observaciones=" + "$_observaciones" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  DispositivoIot copyWith({String? deviceId, String? nombre, String? departamento, String? zona, TipoDispositivo? tipoDispositivo, String? variablesPublicadas, String? localizacion, EstadoDispositivo? estado, String? observaciones, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, List<RelDispositivoGrupoIot>? grupos, List<MedicionIot>? mediciones}) {
    return DispositivoIot._internal(
      id: id,
      deviceId: deviceId ?? this.deviceId,
      nombre: nombre ?? this.nombre,
      departamento: departamento ?? this.departamento,
      zona: zona ?? this.zona,
      tipoDispositivo: tipoDispositivo ?? this.tipoDispositivo,
      variablesPublicadas: variablesPublicadas ?? this.variablesPublicadas,
      localizacion: localizacion ?? this.localizacion,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      grupos: grupos ?? this.grupos,
      mediciones: mediciones ?? this.mediciones);
  }
  
  DispositivoIot copyWithModelFieldValues({
    ModelFieldValue<String>? deviceId,
    ModelFieldValue<String>? nombre,
    ModelFieldValue<String>? departamento,
    ModelFieldValue<String>? zona,
    ModelFieldValue<TipoDispositivo>? tipoDispositivo,
    ModelFieldValue<String>? variablesPublicadas,
    ModelFieldValue<String?>? localizacion,
    ModelFieldValue<EstadoDispositivo>? estado,
    ModelFieldValue<String?>? observaciones,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt,
    ModelFieldValue<List<RelDispositivoGrupoIot>?>? grupos,
    ModelFieldValue<List<MedicionIot>?>? mediciones
  }) {
    return DispositivoIot._internal(
      id: id,
      deviceId: deviceId == null ? this.deviceId : deviceId.value,
      nombre: nombre == null ? this.nombre : nombre.value,
      departamento: departamento == null ? this.departamento : departamento.value,
      zona: zona == null ? this.zona : zona.value,
      tipoDispositivo: tipoDispositivo == null ? this.tipoDispositivo : tipoDispositivo.value,
      variablesPublicadas: variablesPublicadas == null ? this.variablesPublicadas : variablesPublicadas.value,
      localizacion: localizacion == null ? this.localizacion : localizacion.value,
      estado: estado == null ? this.estado : estado.value,
      observaciones: observaciones == null ? this.observaciones : observaciones.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      grupos: grupos == null ? this.grupos : grupos.value,
      mediciones: mediciones == null ? this.mediciones : mediciones.value
    );
  }
  
  DispositivoIot.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _deviceId = json['deviceId'],
      _nombre = json['nombre'],
      _departamento = json['departamento'],
      _zona = json['zona'],
      _tipoDispositivo = amplify_core.enumFromString<TipoDispositivo>(json['tipoDispositivo'], TipoDispositivo.values),
      _variablesPublicadas = json['variablesPublicadas'],
      _localizacion = json['localizacion'],
      _estado = amplify_core.enumFromString<EstadoDispositivo>(json['estado'], EstadoDispositivo.values),
      _observaciones = json['observaciones'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _grupos = json['grupos']  is Map
        ? (json['grupos']['items'] is List
          ? (json['grupos']['items'] as List)
              .where((e) => e != null)
              .map((e) => RelDispositivoGrupoIot.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['grupos'] is List
          ? (json['grupos'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => RelDispositivoGrupoIot.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _mediciones = json['mediciones']  is Map
        ? (json['mediciones']['items'] is List
          ? (json['mediciones']['items'] as List)
              .where((e) => e != null)
              .map((e) => MedicionIot.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['mediciones'] is List
          ? (json['mediciones'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => MedicionIot.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null);
  
  Map<String, dynamic> toJson() => {
    'id': id, 'deviceId': _deviceId, 'nombre': _nombre, 'departamento': _departamento, 'zona': _zona, 'tipoDispositivo': amplify_core.enumToString(_tipoDispositivo), 'variablesPublicadas': _variablesPublicadas, 'localizacion': _localizacion, 'estado': amplify_core.enumToString(_estado), 'observaciones': _observaciones, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'grupos': _grupos?.map((RelDispositivoGrupoIot? e) => e?.toJson()).toList(), 'mediciones': _mediciones?.map((MedicionIot? e) => e?.toJson()).toList()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'deviceId': _deviceId,
    'nombre': _nombre,
    'departamento': _departamento,
    'zona': _zona,
    'tipoDispositivo': _tipoDispositivo,
    'variablesPublicadas': _variablesPublicadas,
    'localizacion': _localizacion,
    'estado': _estado,
    'observaciones': _observaciones,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'grupos': _grupos,
    'mediciones': _mediciones
  };

  static final amplify_core.QueryModelIdentifier<DispositivoIotModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DispositivoIotModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final DEVICEID = amplify_core.QueryField(fieldName: "deviceId");
  static final NOMBRE = amplify_core.QueryField(fieldName: "nombre");
  static final DEPARTAMENTO = amplify_core.QueryField(fieldName: "departamento");
  static final ZONA = amplify_core.QueryField(fieldName: "zona");
  static final TIPODISPOSITIVO = amplify_core.QueryField(fieldName: "tipoDispositivo");
  static final VARIABLESPUBLICADAS = amplify_core.QueryField(fieldName: "variablesPublicadas");
  static final LOCALIZACION = amplify_core.QueryField(fieldName: "localizacion");
  static final ESTADO = amplify_core.QueryField(fieldName: "estado");
  static final OBSERVACIONES = amplify_core.QueryField(fieldName: "observaciones");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final GRUPOS = amplify_core.QueryField(
    fieldName: "grupos",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RelDispositivoGrupoIot'));
  static final MEDICIONES = amplify_core.QueryField(
    fieldName: "mediciones",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'MedicionIot'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "DispositivoIot";
    modelSchemaDefinition.pluralName = "DispositivoIots";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["deviceId"], name: "byDeviceId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.DEVICEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.NOMBRE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.DEPARTAMENTO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.ZONA,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.TIPODISPOSITIVO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.VARIABLESPUBLICADAS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.LOCALIZACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.ESTADO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.OBSERVACIONES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: DispositivoIot.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: DispositivoIot.GRUPOS,
      isRequired: false,
      ofModelName: 'RelDispositivoGrupoIot',
      associatedKey: RelDispositivoGrupoIot.DISPOSITIVO
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: DispositivoIot.MEDICIONES,
      isRequired: false,
      ofModelName: 'MedicionIot',
      associatedKey: MedicionIot.DISPOSITIVO
    ));
  });
}

class _DispositivoIotModelType extends amplify_core.ModelType<DispositivoIot> {
  const _DispositivoIotModelType();
  
  @override
  DispositivoIot fromJson(Map<String, dynamic> jsonData) {
    return DispositivoIot.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'DispositivoIot';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [DispositivoIot] in your schema.
 */
class DispositivoIotModelIdentifier implements amplify_core.ModelIdentifier<DispositivoIot> {
  final String id;

  /** Create an instance of DispositivoIotModelIdentifier using [id] the primary key. */
  const DispositivoIotModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'DispositivoIotModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DispositivoIotModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}