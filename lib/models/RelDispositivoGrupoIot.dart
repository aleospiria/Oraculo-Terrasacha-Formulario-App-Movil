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


/** This is an auto generated class representing the RelDispositivoGrupoIot type in your schema. */
class RelDispositivoGrupoIot extends amplify_core.Model {
  static const classType = const _RelDispositivoGrupoIotModelType();
  final String id;
  final amplify_core.TemporalDateTime? _fechaAsignacion;
  final String? _usuarioId;
  final String? _notas;
  final DispositivoIot? _dispositivo;
  final GrupoIot? _grupo;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RelDispositivoGrupoIotModelIdentifier get modelIdentifier {
      return RelDispositivoGrupoIotModelIdentifier(
        id: id
      );
  }
  
  amplify_core.TemporalDateTime? get fechaAsignacion {
    return _fechaAsignacion;
  }
  
  String? get usuarioId {
    return _usuarioId;
  }
  
  String? get notas {
    return _notas;
  }
  
  DispositivoIot? get dispositivo {
    return _dispositivo;
  }
  
  GrupoIot? get grupo {
    return _grupo;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const RelDispositivoGrupoIot._internal({required this.id, fechaAsignacion, usuarioId, notas, dispositivo, grupo, createdAt, updatedAt}): _fechaAsignacion = fechaAsignacion, _usuarioId = usuarioId, _notas = notas, _dispositivo = dispositivo, _grupo = grupo, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory RelDispositivoGrupoIot({String? id, amplify_core.TemporalDateTime? fechaAsignacion, String? usuarioId, String? notas, DispositivoIot? dispositivo, GrupoIot? grupo}) {
    return RelDispositivoGrupoIot._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      fechaAsignacion: fechaAsignacion,
      usuarioId: usuarioId,
      notas: notas,
      dispositivo: dispositivo,
      grupo: grupo);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelDispositivoGrupoIot &&
      id == other.id &&
      _fechaAsignacion == other._fechaAsignacion &&
      _usuarioId == other._usuarioId &&
      _notas == other._notas &&
      _dispositivo == other._dispositivo &&
      _grupo == other._grupo;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("RelDispositivoGrupoIot {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("fechaAsignacion=" + (_fechaAsignacion != null ? _fechaAsignacion!.format() : "null") + ", ");
    buffer.write("usuarioId=" + "$_usuarioId" + ", ");
    buffer.write("notas=" + "$_notas" + ", ");
    buffer.write("dispositivo=" + (_dispositivo != null ? _dispositivo!.toString() : "null") + ", ");
    buffer.write("grupo=" + (_grupo != null ? _grupo!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  RelDispositivoGrupoIot copyWith({amplify_core.TemporalDateTime? fechaAsignacion, String? usuarioId, String? notas, DispositivoIot? dispositivo, GrupoIot? grupo}) {
    return RelDispositivoGrupoIot._internal(
      id: id,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      usuarioId: usuarioId ?? this.usuarioId,
      notas: notas ?? this.notas,
      dispositivo: dispositivo ?? this.dispositivo,
      grupo: grupo ?? this.grupo);
  }
  
  RelDispositivoGrupoIot copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDateTime?>? fechaAsignacion,
    ModelFieldValue<String?>? usuarioId,
    ModelFieldValue<String?>? notas,
    ModelFieldValue<DispositivoIot?>? dispositivo,
    ModelFieldValue<GrupoIot?>? grupo
  }) {
    return RelDispositivoGrupoIot._internal(
      id: id,
      fechaAsignacion: fechaAsignacion == null ? this.fechaAsignacion : fechaAsignacion.value,
      usuarioId: usuarioId == null ? this.usuarioId : usuarioId.value,
      notas: notas == null ? this.notas : notas.value,
      dispositivo: dispositivo == null ? this.dispositivo : dispositivo.value,
      grupo: grupo == null ? this.grupo : grupo.value
    );
  }
  
  RelDispositivoGrupoIot.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _fechaAsignacion = json['fechaAsignacion'] != null ? amplify_core.TemporalDateTime.fromString(json['fechaAsignacion']) : null,
      _usuarioId = json['usuarioId'],
      _notas = json['notas'],
      _dispositivo = json['dispositivo'] != null
        ? json['dispositivo']['serializedData'] != null
          ? DispositivoIot.fromJson(new Map<String, dynamic>.from(json['dispositivo']['serializedData']))
          : DispositivoIot.fromJson(new Map<String, dynamic>.from(json['dispositivo']))
        : null,
      _grupo = json['grupo'] != null
        ? json['grupo']['serializedData'] != null
          ? GrupoIot.fromJson(new Map<String, dynamic>.from(json['grupo']['serializedData']))
          : GrupoIot.fromJson(new Map<String, dynamic>.from(json['grupo']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'fechaAsignacion': _fechaAsignacion?.format(), 'usuarioId': _usuarioId, 'notas': _notas, 'dispositivo': _dispositivo?.toJson(), 'grupo': _grupo?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'fechaAsignacion': _fechaAsignacion,
    'usuarioId': _usuarioId,
    'notas': _notas,
    'dispositivo': _dispositivo,
    'grupo': _grupo,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RelDispositivoGrupoIotModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RelDispositivoGrupoIotModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final FECHAASIGNACION = amplify_core.QueryField(fieldName: "fechaAsignacion");
  static final USUARIOID = amplify_core.QueryField(fieldName: "usuarioId");
  static final NOTAS = amplify_core.QueryField(fieldName: "notas");
  static final DISPOSITIVO = amplify_core.QueryField(
    fieldName: "dispositivo",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'DispositivoIot'));
  static final GRUPO = amplify_core.QueryField(
    fieldName: "grupo",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'GrupoIot'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "RelDispositivoGrupoIot";
    modelSchemaDefinition.pluralName = "RelDispositivoGrupoIots";
    
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
      amplify_core.ModelIndex(fields: const ["dispositivoId"], name: "byDispositivo"),
      amplify_core.ModelIndex(fields: const ["grupoId"], name: "byGrupo")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RelDispositivoGrupoIot.FECHAASIGNACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RelDispositivoGrupoIot.USUARIOID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RelDispositivoGrupoIot.NOTAS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: RelDispositivoGrupoIot.DISPOSITIVO,
      isRequired: false,
      targetNames: ['dispositivoId'],
      ofModelName: 'DispositivoIot'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: RelDispositivoGrupoIot.GRUPO,
      isRequired: false,
      targetNames: ['grupoId'],
      ofModelName: 'GrupoIot'
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

class _RelDispositivoGrupoIotModelType extends amplify_core.ModelType<RelDispositivoGrupoIot> {
  const _RelDispositivoGrupoIotModelType();
  
  @override
  RelDispositivoGrupoIot fromJson(Map<String, dynamic> jsonData) {
    return RelDispositivoGrupoIot.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'RelDispositivoGrupoIot';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [RelDispositivoGrupoIot] in your schema.
 */
class RelDispositivoGrupoIotModelIdentifier implements amplify_core.ModelIdentifier<RelDispositivoGrupoIot> {
  final String id;

  /** Create an instance of RelDispositivoGrupoIotModelIdentifier using [id] the primary key. */
  const RelDispositivoGrupoIotModelIdentifier({
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
  String toString() => 'RelDispositivoGrupoIotModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RelDispositivoGrupoIotModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}