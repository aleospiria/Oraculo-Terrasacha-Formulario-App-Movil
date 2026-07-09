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


/** This is an auto generated class representing the FormulaHistorial type in your schema. */
class FormulaHistorial extends amplify_core.Model {
  static const classType = const _FormulaHistorialModelType();
  final String id;
  final int? _version;
  final amplify_core.TemporalDateTime? _fechaModificacion;
  final String? _datosJson;
  final String? _usuarioId;
  final ConstructorFormula? _formula;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  FormulaHistorialModelIdentifier get modelIdentifier {
      return FormulaHistorialModelIdentifier(
        id: id
      );
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
  
  amplify_core.TemporalDateTime? get fechaModificacion {
    return _fechaModificacion;
  }
  
  String get datosJson {
    try {
      return _datosJson!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get usuarioId {
    return _usuarioId;
  }
  
  ConstructorFormula? get formula {
    return _formula;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const FormulaHistorial._internal({required this.id, required version, fechaModificacion, required datosJson, usuarioId, formula, createdAt, updatedAt}): _version = version, _fechaModificacion = fechaModificacion, _datosJson = datosJson, _usuarioId = usuarioId, _formula = formula, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory FormulaHistorial({String? id, required int version, amplify_core.TemporalDateTime? fechaModificacion, required String datosJson, String? usuarioId, ConstructorFormula? formula}) {
    return FormulaHistorial._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      version: version,
      fechaModificacion: fechaModificacion,
      datosJson: datosJson,
      usuarioId: usuarioId,
      formula: formula);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FormulaHistorial &&
      id == other.id &&
      _version == other._version &&
      _fechaModificacion == other._fechaModificacion &&
      _datosJson == other._datosJson &&
      _usuarioId == other._usuarioId &&
      _formula == other._formula;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("FormulaHistorial {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("version=" + (_version != null ? _version!.toString() : "null") + ", ");
    buffer.write("fechaModificacion=" + (_fechaModificacion != null ? _fechaModificacion!.format() : "null") + ", ");
    buffer.write("datosJson=" + "$_datosJson" + ", ");
    buffer.write("usuarioId=" + "$_usuarioId" + ", ");
    buffer.write("formula=" + (_formula != null ? _formula!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  FormulaHistorial copyWith({int? version, amplify_core.TemporalDateTime? fechaModificacion, String? datosJson, String? usuarioId, ConstructorFormula? formula}) {
    return FormulaHistorial._internal(
      id: id,
      version: version ?? this.version,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      datosJson: datosJson ?? this.datosJson,
      usuarioId: usuarioId ?? this.usuarioId,
      formula: formula ?? this.formula);
  }
  
  FormulaHistorial copyWithModelFieldValues({
    ModelFieldValue<int>? version,
    ModelFieldValue<amplify_core.TemporalDateTime?>? fechaModificacion,
    ModelFieldValue<String>? datosJson,
    ModelFieldValue<String?>? usuarioId,
    ModelFieldValue<ConstructorFormula?>? formula
  }) {
    return FormulaHistorial._internal(
      id: id,
      version: version == null ? this.version : version.value,
      fechaModificacion: fechaModificacion == null ? this.fechaModificacion : fechaModificacion.value,
      datosJson: datosJson == null ? this.datosJson : datosJson.value,
      usuarioId: usuarioId == null ? this.usuarioId : usuarioId.value,
      formula: formula == null ? this.formula : formula.value
    );
  }
  
  FormulaHistorial.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _version = (json['version'] as num?)?.toInt(),
      _fechaModificacion = json['fechaModificacion'] != null ? amplify_core.TemporalDateTime.fromString(json['fechaModificacion']) : null,
      _datosJson = json['datosJson'],
      _usuarioId = json['usuarioId'],
      _formula = json['formula'] != null
        ? json['formula']['serializedData'] != null
          ? ConstructorFormula.fromJson(new Map<String, dynamic>.from(json['formula']['serializedData']))
          : ConstructorFormula.fromJson(new Map<String, dynamic>.from(json['formula']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'version': _version, 'fechaModificacion': _fechaModificacion?.format(), 'datosJson': _datosJson, 'usuarioId': _usuarioId, 'formula': _formula?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'version': _version,
    'fechaModificacion': _fechaModificacion,
    'datosJson': _datosJson,
    'usuarioId': _usuarioId,
    'formula': _formula,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<FormulaHistorialModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<FormulaHistorialModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final VERSION = amplify_core.QueryField(fieldName: "version");
  static final FECHAMODIFICACION = amplify_core.QueryField(fieldName: "fechaModificacion");
  static final DATOSJSON = amplify_core.QueryField(fieldName: "datosJson");
  static final USUARIOID = amplify_core.QueryField(fieldName: "usuarioId");
  static final FORMULA = amplify_core.QueryField(
    fieldName: "formula",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConstructorFormula'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "FormulaHistorial";
    modelSchemaDefinition.pluralName = "FormulaHistorials";
    
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
      amplify_core.ModelIndex(fields: const ["formulaId"], name: "byFormula"),
      amplify_core.ModelIndex(fields: const ["version"], name: "byVersion"),
      amplify_core.ModelIndex(fields: const ["fechaModificacion"], name: "byFechaModificacion")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: FormulaHistorial.VERSION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: FormulaHistorial.FECHAMODIFICACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: FormulaHistorial.DATOSJSON,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: FormulaHistorial.USUARIOID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: FormulaHistorial.FORMULA,
      isRequired: false,
      targetNames: ['formulaId'],
      ofModelName: 'ConstructorFormula'
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

class _FormulaHistorialModelType extends amplify_core.ModelType<FormulaHistorial> {
  const _FormulaHistorialModelType();
  
  @override
  FormulaHistorial fromJson(Map<String, dynamic> jsonData) {
    return FormulaHistorial.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'FormulaHistorial';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [FormulaHistorial] in your schema.
 */
class FormulaHistorialModelIdentifier implements amplify_core.ModelIdentifier<FormulaHistorial> {
  final String id;

  /** Create an instance of FormulaHistorialModelIdentifier using [id] the primary key. */
  const FormulaHistorialModelIdentifier({
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
  String toString() => 'FormulaHistorialModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is FormulaHistorialModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}