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


/** This is an auto generated class representing the AnalisisCuota type in your schema. */
class AnalisisCuota extends amplify_core.Model {
  static const classType = const _AnalisisCuotaModelType();
  final String id;
  final String? _nombreGrupo;
  final int? _limiteDiario;
  final bool? _activo;
  final amplify_core.TemporalDateTime? _creadoEn;
  final amplify_core.TemporalDateTime? _actualizadoEn;
  final List<AnalisisCuotasUsoDiario>? _usosDiarios;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AnalisisCuotaModelIdentifier get modelIdentifier {
      return AnalisisCuotaModelIdentifier(
        id: id
      );
  }
  
  String get nombreGrupo {
    try {
      return _nombreGrupo!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get limiteDiario {
    try {
      return _limiteDiario!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get activo {
    try {
      return _activo!;
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
  
  amplify_core.TemporalDateTime? get actualizadoEn {
    return _actualizadoEn;
  }
  
  List<AnalisisCuotasUsoDiario>? get usosDiarios {
    return _usosDiarios;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const AnalisisCuota._internal({required this.id, required nombreGrupo, required limiteDiario, required activo, creadoEn, actualizadoEn, usosDiarios, createdAt, updatedAt}): _nombreGrupo = nombreGrupo, _limiteDiario = limiteDiario, _activo = activo, _creadoEn = creadoEn, _actualizadoEn = actualizadoEn, _usosDiarios = usosDiarios, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory AnalisisCuota({String? id, required String nombreGrupo, required int limiteDiario, required bool activo, amplify_core.TemporalDateTime? creadoEn, amplify_core.TemporalDateTime? actualizadoEn, List<AnalisisCuotasUsoDiario>? usosDiarios}) {
    return AnalisisCuota._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      nombreGrupo: nombreGrupo,
      limiteDiario: limiteDiario,
      activo: activo,
      creadoEn: creadoEn,
      actualizadoEn: actualizadoEn,
      usosDiarios: usosDiarios != null ? List<AnalisisCuotasUsoDiario>.unmodifiable(usosDiarios) : usosDiarios);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalisisCuota &&
      id == other.id &&
      _nombreGrupo == other._nombreGrupo &&
      _limiteDiario == other._limiteDiario &&
      _activo == other._activo &&
      _creadoEn == other._creadoEn &&
      _actualizadoEn == other._actualizadoEn &&
      DeepCollectionEquality().equals(_usosDiarios, other._usosDiarios);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AnalisisCuota {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("nombreGrupo=" + "$_nombreGrupo" + ", ");
    buffer.write("limiteDiario=" + (_limiteDiario != null ? _limiteDiario!.toString() : "null") + ", ");
    buffer.write("activo=" + (_activo != null ? _activo!.toString() : "null") + ", ");
    buffer.write("creadoEn=" + (_creadoEn != null ? _creadoEn!.format() : "null") + ", ");
    buffer.write("actualizadoEn=" + (_actualizadoEn != null ? _actualizadoEn!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AnalisisCuota copyWith({String? nombreGrupo, int? limiteDiario, bool? activo, amplify_core.TemporalDateTime? creadoEn, amplify_core.TemporalDateTime? actualizadoEn, List<AnalisisCuotasUsoDiario>? usosDiarios}) {
    return AnalisisCuota._internal(
      id: id,
      nombreGrupo: nombreGrupo ?? this.nombreGrupo,
      limiteDiario: limiteDiario ?? this.limiteDiario,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      usosDiarios: usosDiarios ?? this.usosDiarios);
  }
  
  AnalisisCuota copyWithModelFieldValues({
    ModelFieldValue<String>? nombreGrupo,
    ModelFieldValue<int>? limiteDiario,
    ModelFieldValue<bool>? activo,
    ModelFieldValue<amplify_core.TemporalDateTime?>? creadoEn,
    ModelFieldValue<amplify_core.TemporalDateTime?>? actualizadoEn,
    ModelFieldValue<List<AnalisisCuotasUsoDiario>?>? usosDiarios
  }) {
    return AnalisisCuota._internal(
      id: id,
      nombreGrupo: nombreGrupo == null ? this.nombreGrupo : nombreGrupo.value,
      limiteDiario: limiteDiario == null ? this.limiteDiario : limiteDiario.value,
      activo: activo == null ? this.activo : activo.value,
      creadoEn: creadoEn == null ? this.creadoEn : creadoEn.value,
      actualizadoEn: actualizadoEn == null ? this.actualizadoEn : actualizadoEn.value,
      usosDiarios: usosDiarios == null ? this.usosDiarios : usosDiarios.value
    );
  }
  
  AnalisisCuota.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _nombreGrupo = json['nombreGrupo'],
      _limiteDiario = (json['limiteDiario'] as num?)?.toInt(),
      _activo = json['activo'],
      _creadoEn = json['creadoEn'] != null ? amplify_core.TemporalDateTime.fromString(json['creadoEn']) : null,
      _actualizadoEn = json['actualizadoEn'] != null ? amplify_core.TemporalDateTime.fromString(json['actualizadoEn']) : null,
      _usosDiarios = json['usosDiarios']  is Map
        ? (json['usosDiarios']['items'] is List
          ? (json['usosDiarios']['items'] as List)
              .where((e) => e != null)
              .map((e) => AnalisisCuotasUsoDiario.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['usosDiarios'] is List
          ? (json['usosDiarios'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => AnalisisCuotasUsoDiario.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'nombreGrupo': _nombreGrupo, 'limiteDiario': _limiteDiario, 'activo': _activo, 'creadoEn': _creadoEn?.format(), 'actualizadoEn': _actualizadoEn?.format(), 'usosDiarios': _usosDiarios?.map((AnalisisCuotasUsoDiario? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'nombreGrupo': _nombreGrupo,
    'limiteDiario': _limiteDiario,
    'activo': _activo,
    'creadoEn': _creadoEn,
    'actualizadoEn': _actualizadoEn,
    'usosDiarios': _usosDiarios,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<AnalisisCuotaModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AnalisisCuotaModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NOMBREGRUPO = amplify_core.QueryField(fieldName: "nombreGrupo");
  static final LIMITEDIARIO = amplify_core.QueryField(fieldName: "limiteDiario");
  static final ACTIVO = amplify_core.QueryField(fieldName: "activo");
  static final CREADOEN = amplify_core.QueryField(fieldName: "creadoEn");
  static final ACTUALIZADOEN = amplify_core.QueryField(fieldName: "actualizadoEn");
  static final USOSDIARIOS = amplify_core.QueryField(
    fieldName: "usosDiarios",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'AnalisisCuotasUsoDiario'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AnalisisCuota";
    modelSchemaDefinition.pluralName = "AnalisisCuotas";
    
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
      amplify_core.ModelIndex(fields: const ["nombreGrupo"], name: "byNombreGrupo")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AnalisisCuota.NOMBREGRUPO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AnalisisCuota.LIMITEDIARIO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AnalisisCuota.ACTIVO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AnalisisCuota.CREADOEN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AnalisisCuota.ACTUALIZADOEN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: AnalisisCuota.USOSDIARIOS,
      isRequired: false,
      ofModelName: 'AnalisisCuotasUsoDiario',
      associatedKey: AnalisisCuotasUsoDiario.GRUPO
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

class _AnalisisCuotaModelType extends amplify_core.ModelType<AnalisisCuota> {
  const _AnalisisCuotaModelType();
  
  @override
  AnalisisCuota fromJson(Map<String, dynamic> jsonData) {
    return AnalisisCuota.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'AnalisisCuota';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [AnalisisCuota] in your schema.
 */
class AnalisisCuotaModelIdentifier implements amplify_core.ModelIdentifier<AnalisisCuota> {
  final String id;

  /** Create an instance of AnalisisCuotaModelIdentifier using [id] the primary key. */
  const AnalisisCuotaModelIdentifier({
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
  String toString() => 'AnalisisCuotaModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AnalisisCuotaModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}