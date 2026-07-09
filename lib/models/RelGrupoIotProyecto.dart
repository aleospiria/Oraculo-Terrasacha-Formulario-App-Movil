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


/** This is an auto generated class representing the RelGrupoIotProyecto type in your schema. */
class RelGrupoIotProyecto extends amplify_core.Model {
  static const classType = const _RelGrupoIotProyectoModelType();
  final String id;
  final amplify_core.TemporalDateTime? _fechaAsignacion;
  final String? _usuarioId;
  final String? _notas;
  final GrupoIot? _grupo;
  final Proyecto? _proyecto;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RelGrupoIotProyectoModelIdentifier get modelIdentifier {
      return RelGrupoIotProyectoModelIdentifier(
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
  
  GrupoIot? get grupo {
    return _grupo;
  }
  
  Proyecto? get proyecto {
    return _proyecto;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const RelGrupoIotProyecto._internal({required this.id, fechaAsignacion, usuarioId, notas, grupo, proyecto, createdAt, updatedAt}): _fechaAsignacion = fechaAsignacion, _usuarioId = usuarioId, _notas = notas, _grupo = grupo, _proyecto = proyecto, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory RelGrupoIotProyecto({String? id, amplify_core.TemporalDateTime? fechaAsignacion, String? usuarioId, String? notas, GrupoIot? grupo, Proyecto? proyecto}) {
    return RelGrupoIotProyecto._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      fechaAsignacion: fechaAsignacion,
      usuarioId: usuarioId,
      notas: notas,
      grupo: grupo,
      proyecto: proyecto);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelGrupoIotProyecto &&
      id == other.id &&
      _fechaAsignacion == other._fechaAsignacion &&
      _usuarioId == other._usuarioId &&
      _notas == other._notas &&
      _grupo == other._grupo &&
      _proyecto == other._proyecto;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("RelGrupoIotProyecto {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("fechaAsignacion=" + (_fechaAsignacion != null ? _fechaAsignacion!.format() : "null") + ", ");
    buffer.write("usuarioId=" + "$_usuarioId" + ", ");
    buffer.write("notas=" + "$_notas" + ", ");
    buffer.write("grupo=" + (_grupo != null ? _grupo!.toString() : "null") + ", ");
    buffer.write("proyecto=" + (_proyecto != null ? _proyecto!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  RelGrupoIotProyecto copyWith({amplify_core.TemporalDateTime? fechaAsignacion, String? usuarioId, String? notas, GrupoIot? grupo, Proyecto? proyecto}) {
    return RelGrupoIotProyecto._internal(
      id: id,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      usuarioId: usuarioId ?? this.usuarioId,
      notas: notas ?? this.notas,
      grupo: grupo ?? this.grupo,
      proyecto: proyecto ?? this.proyecto);
  }
  
  RelGrupoIotProyecto copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDateTime?>? fechaAsignacion,
    ModelFieldValue<String?>? usuarioId,
    ModelFieldValue<String?>? notas,
    ModelFieldValue<GrupoIot?>? grupo,
    ModelFieldValue<Proyecto?>? proyecto
  }) {
    return RelGrupoIotProyecto._internal(
      id: id,
      fechaAsignacion: fechaAsignacion == null ? this.fechaAsignacion : fechaAsignacion.value,
      usuarioId: usuarioId == null ? this.usuarioId : usuarioId.value,
      notas: notas == null ? this.notas : notas.value,
      grupo: grupo == null ? this.grupo : grupo.value,
      proyecto: proyecto == null ? this.proyecto : proyecto.value
    );
  }
  
  RelGrupoIotProyecto.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _fechaAsignacion = json['fechaAsignacion'] != null ? amplify_core.TemporalDateTime.fromString(json['fechaAsignacion']) : null,
      _usuarioId = json['usuarioId'],
      _notas = json['notas'],
      _grupo = json['grupo'] != null
        ? json['grupo']['serializedData'] != null
          ? GrupoIot.fromJson(new Map<String, dynamic>.from(json['grupo']['serializedData']))
          : GrupoIot.fromJson(new Map<String, dynamic>.from(json['grupo']))
        : null,
      _proyecto = json['proyecto'] != null
        ? json['proyecto']['serializedData'] != null
          ? Proyecto.fromJson(new Map<String, dynamic>.from(json['proyecto']['serializedData']))
          : Proyecto.fromJson(new Map<String, dynamic>.from(json['proyecto']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'fechaAsignacion': _fechaAsignacion?.format(), 'usuarioId': _usuarioId, 'notas': _notas, 'grupo': _grupo?.toJson(), 'proyecto': _proyecto?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'fechaAsignacion': _fechaAsignacion,
    'usuarioId': _usuarioId,
    'notas': _notas,
    'grupo': _grupo,
    'proyecto': _proyecto,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RelGrupoIotProyectoModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RelGrupoIotProyectoModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final FECHAASIGNACION = amplify_core.QueryField(fieldName: "fechaAsignacion");
  static final USUARIOID = amplify_core.QueryField(fieldName: "usuarioId");
  static final NOTAS = amplify_core.QueryField(fieldName: "notas");
  static final GRUPO = amplify_core.QueryField(
    fieldName: "grupo",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'GrupoIot'));
  static final PROYECTO = amplify_core.QueryField(
    fieldName: "proyecto",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Proyecto'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "RelGrupoIotProyecto";
    modelSchemaDefinition.pluralName = "RelGrupoIotProyectos";
    
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
      amplify_core.ModelIndex(fields: const ["grupoId"], name: "byGrupo"),
      amplify_core.ModelIndex(fields: const ["proyectoId"], name: "byProyecto")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RelGrupoIotProyecto.FECHAASIGNACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RelGrupoIotProyecto.USUARIOID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RelGrupoIotProyecto.NOTAS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: RelGrupoIotProyecto.GRUPO,
      isRequired: false,
      targetNames: ['grupoId'],
      ofModelName: 'GrupoIot'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: RelGrupoIotProyecto.PROYECTO,
      isRequired: false,
      targetNames: ['proyectoId'],
      ofModelName: 'Proyecto'
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

class _RelGrupoIotProyectoModelType extends amplify_core.ModelType<RelGrupoIotProyecto> {
  const _RelGrupoIotProyectoModelType();
  
  @override
  RelGrupoIotProyecto fromJson(Map<String, dynamic> jsonData) {
    return RelGrupoIotProyecto.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'RelGrupoIotProyecto';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [RelGrupoIotProyecto] in your schema.
 */
class RelGrupoIotProyectoModelIdentifier implements amplify_core.ModelIdentifier<RelGrupoIotProyecto> {
  final String id;

  /** Create an instance of RelGrupoIotProyectoModelIdentifier using [id] the primary key. */
  const RelGrupoIotProyectoModelIdentifier({
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
  String toString() => 'RelGrupoIotProyectoModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RelGrupoIotProyectoModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}