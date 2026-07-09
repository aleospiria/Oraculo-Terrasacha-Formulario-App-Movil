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


/** This is an auto generated class representing the ConstructorFormula type in your schema. */
class ConstructorFormula extends amplify_core.Model {
  static const classType = const _ConstructorFormulaModelType();
  final String id;
  final String? _nombre;
  final String? _descripcion;
  final String? _fuente;
  final String? _usuarioId;
  final TipoFormula? _tipoFormula;
  final bool? _estado;
  final String? _expresionJson;
  final amplify_core.TemporalDateTime? _fechaCreacion;
  final int? _version;
  final bool? _versionActiva;
  final List<ConstructorFormulaVariableRel>? _variables;
  final List<FormulaTeledeteccion>? _teledeteccion;
  final List<FormulaDeepLearning>? _deepLearning;
  final List<FormulaHistorial>? _historial;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConstructorFormulaModelIdentifier get modelIdentifier {
      return ConstructorFormulaModelIdentifier(
        id: id
      );
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
  
  String get descripcion {
    try {
      return _descripcion!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get fuente {
    return _fuente;
  }
  
  String? get usuarioId {
    return _usuarioId;
  }
  
  TipoFormula get tipoFormula {
    try {
      return _tipoFormula!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get estado {
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
  
  String? get expresionJson {
    return _expresionJson;
  }
  
  amplify_core.TemporalDateTime? get fechaCreacion {
    return _fechaCreacion;
  }
  
  int get version {
    try {
      return _version!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get versionActiva {
    try {
      return _versionActiva!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<ConstructorFormulaVariableRel>? get variables {
    return _variables;
  }
  
  List<FormulaTeledeteccion>? get teledeteccion {
    return _teledeteccion;
  }
  
  List<FormulaDeepLearning>? get deepLearning {
    return _deepLearning;
  }
  
  List<FormulaHistorial>? get historial {
    return _historial;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ConstructorFormula._internal({required this.id, required nombre, required descripcion, fuente, usuarioId, required tipoFormula, required estado, expresionJson, fechaCreacion, required version, required versionActiva, variables, teledeteccion, deepLearning, historial, createdAt, updatedAt}): _nombre = nombre, _descripcion = descripcion, _fuente = fuente, _usuarioId = usuarioId, _tipoFormula = tipoFormula, _estado = estado, _expresionJson = expresionJson, _fechaCreacion = fechaCreacion, _version = version, _versionActiva = versionActiva, _variables = variables, _teledeteccion = teledeteccion, _deepLearning = deepLearning, _historial = historial, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ConstructorFormula({String? id, required String nombre, required String descripcion, String? fuente, String? usuarioId, required TipoFormula tipoFormula, required bool estado, String? expresionJson, amplify_core.TemporalDateTime? fechaCreacion, required int version, required bool versionActiva, List<ConstructorFormulaVariableRel>? variables, List<FormulaTeledeteccion>? teledeteccion, List<FormulaDeepLearning>? deepLearning, List<FormulaHistorial>? historial}) {
    return ConstructorFormula._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      nombre: nombre,
      descripcion: descripcion,
      fuente: fuente,
      usuarioId: usuarioId,
      tipoFormula: tipoFormula,
      estado: estado,
      expresionJson: expresionJson,
      fechaCreacion: fechaCreacion,
      version: version,
      versionActiva: versionActiva,
      variables: variables != null ? List<ConstructorFormulaVariableRel>.unmodifiable(variables) : variables,
      teledeteccion: teledeteccion != null ? List<FormulaTeledeteccion>.unmodifiable(teledeteccion) : teledeteccion,
      deepLearning: deepLearning != null ? List<FormulaDeepLearning>.unmodifiable(deepLearning) : deepLearning,
      historial: historial != null ? List<FormulaHistorial>.unmodifiable(historial) : historial);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConstructorFormula &&
      id == other.id &&
      _nombre == other._nombre &&
      _descripcion == other._descripcion &&
      _fuente == other._fuente &&
      _usuarioId == other._usuarioId &&
      _tipoFormula == other._tipoFormula &&
      _estado == other._estado &&
      _expresionJson == other._expresionJson &&
      _fechaCreacion == other._fechaCreacion &&
      _version == other._version &&
      _versionActiva == other._versionActiva &&
      DeepCollectionEquality().equals(_variables, other._variables) &&
      DeepCollectionEquality().equals(_teledeteccion, other._teledeteccion) &&
      DeepCollectionEquality().equals(_deepLearning, other._deepLearning) &&
      DeepCollectionEquality().equals(_historial, other._historial);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ConstructorFormula {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("nombre=" + "$_nombre" + ", ");
    buffer.write("descripcion=" + "$_descripcion" + ", ");
    buffer.write("fuente=" + "$_fuente" + ", ");
    buffer.write("usuarioId=" + "$_usuarioId" + ", ");
    buffer.write("tipoFormula=" + (_tipoFormula != null ? amplify_core.enumToString(_tipoFormula)! : "null") + ", ");
    buffer.write("estado=" + (_estado != null ? _estado!.toString() : "null") + ", ");
    buffer.write("expresionJson=" + "$_expresionJson" + ", ");
    buffer.write("fechaCreacion=" + (_fechaCreacion != null ? _fechaCreacion!.format() : "null") + ", ");
    buffer.write("version=" + (_version != null ? _version!.toString() : "null") + ", ");
    buffer.write("versionActiva=" + (_versionActiva != null ? _versionActiva!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ConstructorFormula copyWith({String? nombre, String? descripcion, String? fuente, String? usuarioId, TipoFormula? tipoFormula, bool? estado, String? expresionJson, amplify_core.TemporalDateTime? fechaCreacion, int? version, bool? versionActiva, List<ConstructorFormulaVariableRel>? variables, List<FormulaTeledeteccion>? teledeteccion, List<FormulaDeepLearning>? deepLearning, List<FormulaHistorial>? historial}) {
    return ConstructorFormula._internal(
      id: id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      fuente: fuente ?? this.fuente,
      usuarioId: usuarioId ?? this.usuarioId,
      tipoFormula: tipoFormula ?? this.tipoFormula,
      estado: estado ?? this.estado,
      expresionJson: expresionJson ?? this.expresionJson,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      version: version ?? this.version,
      versionActiva: versionActiva ?? this.versionActiva,
      variables: variables ?? this.variables,
      teledeteccion: teledeteccion ?? this.teledeteccion,
      deepLearning: deepLearning ?? this.deepLearning,
      historial: historial ?? this.historial);
  }
  
  ConstructorFormula copyWithModelFieldValues({
    ModelFieldValue<String>? nombre,
    ModelFieldValue<String>? descripcion,
    ModelFieldValue<String?>? fuente,
    ModelFieldValue<String?>? usuarioId,
    ModelFieldValue<TipoFormula>? tipoFormula,
    ModelFieldValue<bool>? estado,
    ModelFieldValue<String?>? expresionJson,
    ModelFieldValue<amplify_core.TemporalDateTime?>? fechaCreacion,
    ModelFieldValue<int>? version,
    ModelFieldValue<bool>? versionActiva,
    ModelFieldValue<List<ConstructorFormulaVariableRel>?>? variables,
    ModelFieldValue<List<FormulaTeledeteccion>?>? teledeteccion,
    ModelFieldValue<List<FormulaDeepLearning>?>? deepLearning,
    ModelFieldValue<List<FormulaHistorial>?>? historial
  }) {
    return ConstructorFormula._internal(
      id: id,
      nombre: nombre == null ? this.nombre : nombre.value,
      descripcion: descripcion == null ? this.descripcion : descripcion.value,
      fuente: fuente == null ? this.fuente : fuente.value,
      usuarioId: usuarioId == null ? this.usuarioId : usuarioId.value,
      tipoFormula: tipoFormula == null ? this.tipoFormula : tipoFormula.value,
      estado: estado == null ? this.estado : estado.value,
      expresionJson: expresionJson == null ? this.expresionJson : expresionJson.value,
      fechaCreacion: fechaCreacion == null ? this.fechaCreacion : fechaCreacion.value,
      version: version == null ? this.version : version.value,
      versionActiva: versionActiva == null ? this.versionActiva : versionActiva.value,
      variables: variables == null ? this.variables : variables.value,
      teledeteccion: teledeteccion == null ? this.teledeteccion : teledeteccion.value,
      deepLearning: deepLearning == null ? this.deepLearning : deepLearning.value,
      historial: historial == null ? this.historial : historial.value
    );
  }
  
  ConstructorFormula.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _nombre = json['nombre'],
      _descripcion = json['descripcion'],
      _fuente = json['fuente'],
      _usuarioId = json['usuarioId'],
      _tipoFormula = amplify_core.enumFromString<TipoFormula>(json['tipoFormula'], TipoFormula.values),
      _estado = json['estado'],
      _expresionJson = json['expresionJson'],
      _fechaCreacion = json['fechaCreacion'] != null ? amplify_core.TemporalDateTime.fromString(json['fechaCreacion']) : null,
      _version = (json['version'] as num?)?.toInt(),
      _versionActiva = json['versionActiva'],
      _variables = json['variables']  is Map
        ? (json['variables']['items'] is List
          ? (json['variables']['items'] as List)
              .where((e) => e != null)
              .map((e) => ConstructorFormulaVariableRel.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['variables'] is List
          ? (json['variables'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ConstructorFormulaVariableRel.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _teledeteccion = json['teledeteccion']  is Map
        ? (json['teledeteccion']['items'] is List
          ? (json['teledeteccion']['items'] as List)
              .where((e) => e != null)
              .map((e) => FormulaTeledeteccion.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['teledeteccion'] is List
          ? (json['teledeteccion'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => FormulaTeledeteccion.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _deepLearning = json['deepLearning']  is Map
        ? (json['deepLearning']['items'] is List
          ? (json['deepLearning']['items'] as List)
              .where((e) => e != null)
              .map((e) => FormulaDeepLearning.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['deepLearning'] is List
          ? (json['deepLearning'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => FormulaDeepLearning.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _historial = json['historial']  is Map
        ? (json['historial']['items'] is List
          ? (json['historial']['items'] as List)
              .where((e) => e != null)
              .map((e) => FormulaHistorial.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['historial'] is List
          ? (json['historial'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => FormulaHistorial.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'nombre': _nombre, 'descripcion': _descripcion, 'fuente': _fuente, 'usuarioId': _usuarioId, 'tipoFormula': amplify_core.enumToString(_tipoFormula), 'estado': _estado, 'expresionJson': _expresionJson, 'fechaCreacion': _fechaCreacion?.format(), 'version': _version, 'versionActiva': _versionActiva, 'variables': _variables?.map((ConstructorFormulaVariableRel? e) => e?.toJson()).toList(), 'teledeteccion': _teledeteccion?.map((FormulaTeledeteccion? e) => e?.toJson()).toList(), 'deepLearning': _deepLearning?.map((FormulaDeepLearning? e) => e?.toJson()).toList(), 'historial': _historial?.map((FormulaHistorial? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'nombre': _nombre,
    'descripcion': _descripcion,
    'fuente': _fuente,
    'usuarioId': _usuarioId,
    'tipoFormula': _tipoFormula,
    'estado': _estado,
    'expresionJson': _expresionJson,
    'fechaCreacion': _fechaCreacion,
    'version': _version,
    'versionActiva': _versionActiva,
    'variables': _variables,
    'teledeteccion': _teledeteccion,
    'deepLearning': _deepLearning,
    'historial': _historial,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConstructorFormulaModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConstructorFormulaModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NOMBRE = amplify_core.QueryField(fieldName: "nombre");
  static final DESCRIPCION = amplify_core.QueryField(fieldName: "descripcion");
  static final FUENTE = amplify_core.QueryField(fieldName: "fuente");
  static final USUARIOID = amplify_core.QueryField(fieldName: "usuarioId");
  static final TIPOFORMULA = amplify_core.QueryField(fieldName: "tipoFormula");
  static final ESTADO = amplify_core.QueryField(fieldName: "estado");
  static final EXPRESIONJSON = amplify_core.QueryField(fieldName: "expresionJson");
  static final FECHACREACION = amplify_core.QueryField(fieldName: "fechaCreacion");
  static final VERSION = amplify_core.QueryField(fieldName: "version");
  static final VERSIONACTIVA = amplify_core.QueryField(fieldName: "versionActiva");
  static final VARIABLES = amplify_core.QueryField(
    fieldName: "variables",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConstructorFormulaVariableRel'));
  static final TELEDETECCION = amplify_core.QueryField(
    fieldName: "teledeteccion",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'FormulaTeledeteccion'));
  static final DEEPLEARNING = amplify_core.QueryField(
    fieldName: "deepLearning",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'FormulaDeepLearning'));
  static final HISTORIAL = amplify_core.QueryField(
    fieldName: "historial",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'FormulaHistorial'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ConstructorFormula";
    modelSchemaDefinition.pluralName = "ConstructorFormulas";
    
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
      amplify_core.ModelIndex(fields: const ["nombre"], name: "byNombre"),
      amplify_core.ModelIndex(fields: const ["usuarioId"], name: "byUsuario")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.NOMBRE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.DESCRIPCION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.FUENTE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.USUARIOID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.TIPOFORMULA,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.ESTADO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.EXPRESIONJSON,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.FECHACREACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.VERSION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConstructorFormula.VERSIONACTIVA,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ConstructorFormula.VARIABLES,
      isRequired: false,
      ofModelName: 'ConstructorFormulaVariableRel',
      associatedKey: ConstructorFormulaVariableRel.FORMULA
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ConstructorFormula.TELEDETECCION,
      isRequired: false,
      ofModelName: 'FormulaTeledeteccion',
      associatedKey: FormulaTeledeteccion.FORMULA
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ConstructorFormula.DEEPLEARNING,
      isRequired: false,
      ofModelName: 'FormulaDeepLearning',
      associatedKey: FormulaDeepLearning.FORMULA
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ConstructorFormula.HISTORIAL,
      isRequired: false,
      ofModelName: 'FormulaHistorial',
      associatedKey: FormulaHistorial.FORMULA
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ConstructorFormulaModelType extends amplify_core.ModelType<ConstructorFormula> {
  const _ConstructorFormulaModelType();
  
  @override
  ConstructorFormula fromJson(Map<String, dynamic> jsonData) {
    return ConstructorFormula.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ConstructorFormula';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ConstructorFormula] in your schema.
 */
class ConstructorFormulaModelIdentifier implements amplify_core.ModelIdentifier<ConstructorFormula> {
  final String id;

  /** Create an instance of ConstructorFormulaModelIdentifier using [id] the primary key. */
  const ConstructorFormulaModelIdentifier({
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
  String toString() => 'ConstructorFormulaModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConstructorFormulaModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}