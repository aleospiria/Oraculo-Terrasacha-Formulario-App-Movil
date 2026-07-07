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


/** This is an auto generated class representing the AnalisisCuotasUsoDiario type in your schema. */
class AnalisisCuotasUsoDiario extends amplify_core.Model {
  static const classType = const _AnalisisCuotasUsoDiarioModelType();
  final String id;
  final String? _usuarioNombre;
  final amplify_core.TemporalDateTime? _fechaUso;
  final amplify_core.TemporalDateTime? _creadoEn;
  final ConsultaAnalisis? _consulta;
  final AnalisisCuota? _grupo;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AnalisisCuotasUsoDiarioModelIdentifier get modelIdentifier {
      return AnalisisCuotasUsoDiarioModelIdentifier(
        id: id
      );
  }
  
  String get usuarioNombre {
    try {
      return _usuarioNombre!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get fechaUso {
    try {
      return _fechaUso!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get creadoEn {
    return _creadoEn;
  }
  
  ConsultaAnalisis? get consulta {
    return _consulta;
  }
  
  AnalisisCuota? get grupo {
    return _grupo;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const AnalisisCuotasUsoDiario._internal({required this.id, required usuarioNombre, required fechaUso, creadoEn, consulta, grupo, createdAt, updatedAt}): _usuarioNombre = usuarioNombre, _fechaUso = fechaUso, _creadoEn = creadoEn, _consulta = consulta, _grupo = grupo, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory AnalisisCuotasUsoDiario({String? id, required String usuarioNombre, required amplify_core.TemporalDateTime fechaUso, amplify_core.TemporalDateTime? creadoEn, ConsultaAnalisis? consulta, AnalisisCuota? grupo}) {
    return AnalisisCuotasUsoDiario._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      usuarioNombre: usuarioNombre,
      fechaUso: fechaUso,
      creadoEn: creadoEn,
      consulta: consulta,
      grupo: grupo);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalisisCuotasUsoDiario &&
      id == other.id &&
      _usuarioNombre == other._usuarioNombre &&
      _fechaUso == other._fechaUso &&
      _creadoEn == other._creadoEn &&
      _consulta == other._consulta &&
      _grupo == other._grupo;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AnalisisCuotasUsoDiario {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("usuarioNombre=" + "$_usuarioNombre" + ", ");
    buffer.write("fechaUso=" + (_fechaUso != null ? _fechaUso!.format() : "null") + ", ");
    buffer.write("creadoEn=" + (_creadoEn != null ? _creadoEn!.format() : "null") + ", ");
    buffer.write("consulta=" + (_consulta != null ? _consulta!.toString() : "null") + ", ");
    buffer.write("grupo=" + (_grupo != null ? _grupo!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AnalisisCuotasUsoDiario copyWith({String? usuarioNombre, amplify_core.TemporalDateTime? fechaUso, amplify_core.TemporalDateTime? creadoEn, ConsultaAnalisis? consulta, AnalisisCuota? grupo}) {
    return AnalisisCuotasUsoDiario._internal(
      id: id,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fechaUso: fechaUso ?? this.fechaUso,
      creadoEn: creadoEn ?? this.creadoEn,
      consulta: consulta ?? this.consulta,
      grupo: grupo ?? this.grupo);
  }
  
  AnalisisCuotasUsoDiario copyWithModelFieldValues({
    ModelFieldValue<String>? usuarioNombre,
    ModelFieldValue<amplify_core.TemporalDateTime>? fechaUso,
    ModelFieldValue<amplify_core.TemporalDateTime?>? creadoEn,
    ModelFieldValue<ConsultaAnalisis?>? consulta,
    ModelFieldValue<AnalisisCuota?>? grupo
  }) {
    return AnalisisCuotasUsoDiario._internal(
      id: id,
      usuarioNombre: usuarioNombre == null ? this.usuarioNombre : usuarioNombre.value,
      fechaUso: fechaUso == null ? this.fechaUso : fechaUso.value,
      creadoEn: creadoEn == null ? this.creadoEn : creadoEn.value,
      consulta: consulta == null ? this.consulta : consulta.value,
      grupo: grupo == null ? this.grupo : grupo.value
    );
  }
  
  AnalisisCuotasUsoDiario.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _usuarioNombre = json['usuarioNombre'],
      _fechaUso = json['fechaUso'] != null ? amplify_core.TemporalDateTime.fromString(json['fechaUso']) : null,
      _creadoEn = json['creadoEn'] != null ? amplify_core.TemporalDateTime.fromString(json['creadoEn']) : null,
      _consulta = json['consulta'] != null
        ? json['consulta']['serializedData'] != null
          ? ConsultaAnalisis.fromJson(new Map<String, dynamic>.from(json['consulta']['serializedData']))
          : ConsultaAnalisis.fromJson(new Map<String, dynamic>.from(json['consulta']))
        : null,
      _grupo = json['grupo'] != null
        ? json['grupo']['serializedData'] != null
          ? AnalisisCuota.fromJson(new Map<String, dynamic>.from(json['grupo']['serializedData']))
          : AnalisisCuota.fromJson(new Map<String, dynamic>.from(json['grupo']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'usuarioNombre': _usuarioNombre, 'fechaUso': _fechaUso?.format(), 'creadoEn': _creadoEn?.format(), 'consulta': _consulta?.toJson(), 'grupo': _grupo?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'usuarioNombre': _usuarioNombre,
    'fechaUso': _fechaUso,
    'creadoEn': _creadoEn,
    'consulta': _consulta,
    'grupo': _grupo,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<AnalisisCuotasUsoDiarioModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AnalisisCuotasUsoDiarioModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USUARIONOMBRE = amplify_core.QueryField(fieldName: "usuarioNombre");
  static final FECHAUSO = amplify_core.QueryField(fieldName: "fechaUso");
  static final CREADOEN = amplify_core.QueryField(fieldName: "creadoEn");
  static final CONSULTA = amplify_core.QueryField(
    fieldName: "consulta",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConsultaAnalisis'));
  static final GRUPO = amplify_core.QueryField(
    fieldName: "grupo",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'AnalisisCuota'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AnalisisCuotasUsoDiario";
    modelSchemaDefinition.pluralName = "AnalisisCuotasUsoDiarios";
    
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
      amplify_core.ModelIndex(fields: const ["usuarioNombre"], name: "byUsuario"),
      amplify_core.ModelIndex(fields: const ["grupoId"], name: "byGrupo"),
      amplify_core.ModelIndex(fields: const ["fechaUso"], name: "byFechaUso"),
      amplify_core.ModelIndex(fields: const ["consultaId"], name: "byConsulta")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AnalisisCuotasUsoDiario.USUARIONOMBRE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AnalisisCuotasUsoDiario.FECHAUSO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AnalisisCuotasUsoDiario.CREADOEN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: AnalisisCuotasUsoDiario.CONSULTA,
      isRequired: false,
      targetNames: ['consultaId'],
      ofModelName: 'ConsultaAnalisis'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: AnalisisCuotasUsoDiario.GRUPO,
      isRequired: false,
      targetNames: ['grupoId'],
      ofModelName: 'AnalisisCuota'
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

class _AnalisisCuotasUsoDiarioModelType extends amplify_core.ModelType<AnalisisCuotasUsoDiario> {
  const _AnalisisCuotasUsoDiarioModelType();
  
  @override
  AnalisisCuotasUsoDiario fromJson(Map<String, dynamic> jsonData) {
    return AnalisisCuotasUsoDiario.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'AnalisisCuotasUsoDiario';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [AnalisisCuotasUsoDiario] in your schema.
 */
class AnalisisCuotasUsoDiarioModelIdentifier implements amplify_core.ModelIdentifier<AnalisisCuotasUsoDiario> {
  final String id;

  /** Create an instance of AnalisisCuotasUsoDiarioModelIdentifier using [id] the primary key. */
  const AnalisisCuotasUsoDiarioModelIdentifier({
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
  String toString() => 'AnalisisCuotasUsoDiarioModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AnalisisCuotasUsoDiarioModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}