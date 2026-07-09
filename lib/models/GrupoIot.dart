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


/** This is an auto generated class representing the GrupoIot type in your schema. */
class GrupoIot extends amplify_core.Model {
  static const classType = const _GrupoIotModelType();
  final String id;
  final String? _nombre;
  final String? _descripcion;
  final EstadoDispositivo? _estado;
  final String? _usuarioCreador;
  final String? _observaciones;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final List<RelDispositivoGrupoIot>? _dispositivos;
  final List<RelGrupoIotProyecto>? _proyectos;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GrupoIotModelIdentifier get modelIdentifier {
      return GrupoIotModelIdentifier(
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
  
  String? get descripcion {
    return _descripcion;
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
  
  String? get usuarioCreador {
    return _usuarioCreador;
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
  
  List<RelDispositivoGrupoIot>? get dispositivos {
    return _dispositivos;
  }
  
  List<RelGrupoIotProyecto>? get proyectos {
    return _proyectos;
  }
  
  const GrupoIot._internal({required this.id, required nombre, descripcion, required estado, usuarioCreador, observaciones, createdAt, updatedAt, dispositivos, proyectos}): _nombre = nombre, _descripcion = descripcion, _estado = estado, _usuarioCreador = usuarioCreador, _observaciones = observaciones, _createdAt = createdAt, _updatedAt = updatedAt, _dispositivos = dispositivos, _proyectos = proyectos;
  
  factory GrupoIot({String? id, required String nombre, String? descripcion, required EstadoDispositivo estado, String? usuarioCreador, String? observaciones, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, List<RelDispositivoGrupoIot>? dispositivos, List<RelGrupoIotProyecto>? proyectos}) {
    return GrupoIot._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      nombre: nombre,
      descripcion: descripcion,
      estado: estado,
      usuarioCreador: usuarioCreador,
      observaciones: observaciones,
      createdAt: createdAt,
      updatedAt: updatedAt,
      dispositivos: dispositivos != null ? List<RelDispositivoGrupoIot>.unmodifiable(dispositivos) : dispositivos,
      proyectos: proyectos != null ? List<RelGrupoIotProyecto>.unmodifiable(proyectos) : proyectos);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GrupoIot &&
      id == other.id &&
      _nombre == other._nombre &&
      _descripcion == other._descripcion &&
      _estado == other._estado &&
      _usuarioCreador == other._usuarioCreador &&
      _observaciones == other._observaciones &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt &&
      DeepCollectionEquality().equals(_dispositivos, other._dispositivos) &&
      DeepCollectionEquality().equals(_proyectos, other._proyectos);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("GrupoIot {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("nombre=" + "$_nombre" + ", ");
    buffer.write("descripcion=" + "$_descripcion" + ", ");
    buffer.write("estado=" + (_estado != null ? amplify_core.enumToString(_estado)! : "null") + ", ");
    buffer.write("usuarioCreador=" + "$_usuarioCreador" + ", ");
    buffer.write("observaciones=" + "$_observaciones" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  GrupoIot copyWith({String? nombre, String? descripcion, EstadoDispositivo? estado, String? usuarioCreador, String? observaciones, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, List<RelDispositivoGrupoIot>? dispositivos, List<RelGrupoIotProyecto>? proyectos}) {
    return GrupoIot._internal(
      id: id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      usuarioCreador: usuarioCreador ?? this.usuarioCreador,
      observaciones: observaciones ?? this.observaciones,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dispositivos: dispositivos ?? this.dispositivos,
      proyectos: proyectos ?? this.proyectos);
  }
  
  GrupoIot copyWithModelFieldValues({
    ModelFieldValue<String>? nombre,
    ModelFieldValue<String?>? descripcion,
    ModelFieldValue<EstadoDispositivo>? estado,
    ModelFieldValue<String?>? usuarioCreador,
    ModelFieldValue<String?>? observaciones,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt,
    ModelFieldValue<List<RelDispositivoGrupoIot>?>? dispositivos,
    ModelFieldValue<List<RelGrupoIotProyecto>?>? proyectos
  }) {
    return GrupoIot._internal(
      id: id,
      nombre: nombre == null ? this.nombre : nombre.value,
      descripcion: descripcion == null ? this.descripcion : descripcion.value,
      estado: estado == null ? this.estado : estado.value,
      usuarioCreador: usuarioCreador == null ? this.usuarioCreador : usuarioCreador.value,
      observaciones: observaciones == null ? this.observaciones : observaciones.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      dispositivos: dispositivos == null ? this.dispositivos : dispositivos.value,
      proyectos: proyectos == null ? this.proyectos : proyectos.value
    );
  }
  
  GrupoIot.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _nombre = json['nombre'],
      _descripcion = json['descripcion'],
      _estado = amplify_core.enumFromString<EstadoDispositivo>(json['estado'], EstadoDispositivo.values),
      _usuarioCreador = json['usuarioCreador'],
      _observaciones = json['observaciones'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _dispositivos = json['dispositivos']  is Map
        ? (json['dispositivos']['items'] is List
          ? (json['dispositivos']['items'] as List)
              .where((e) => e != null)
              .map((e) => RelDispositivoGrupoIot.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['dispositivos'] is List
          ? (json['dispositivos'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => RelDispositivoGrupoIot.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _proyectos = json['proyectos']  is Map
        ? (json['proyectos']['items'] is List
          ? (json['proyectos']['items'] as List)
              .where((e) => e != null)
              .map((e) => RelGrupoIotProyecto.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['proyectos'] is List
          ? (json['proyectos'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => RelGrupoIotProyecto.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null);
  
  Map<String, dynamic> toJson() => {
    'id': id, 'nombre': _nombre, 'descripcion': _descripcion, 'estado': amplify_core.enumToString(_estado), 'usuarioCreador': _usuarioCreador, 'observaciones': _observaciones, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'dispositivos': _dispositivos?.map((RelDispositivoGrupoIot? e) => e?.toJson()).toList(), 'proyectos': _proyectos?.map((RelGrupoIotProyecto? e) => e?.toJson()).toList()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'nombre': _nombre,
    'descripcion': _descripcion,
    'estado': _estado,
    'usuarioCreador': _usuarioCreador,
    'observaciones': _observaciones,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'dispositivos': _dispositivos,
    'proyectos': _proyectos
  };

  static final amplify_core.QueryModelIdentifier<GrupoIotModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GrupoIotModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NOMBRE = amplify_core.QueryField(fieldName: "nombre");
  static final DESCRIPCION = amplify_core.QueryField(fieldName: "descripcion");
  static final ESTADO = amplify_core.QueryField(fieldName: "estado");
  static final USUARIOCREADOR = amplify_core.QueryField(fieldName: "usuarioCreador");
  static final OBSERVACIONES = amplify_core.QueryField(fieldName: "observaciones");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final DISPOSITIVOS = amplify_core.QueryField(
    fieldName: "dispositivos",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RelDispositivoGrupoIot'));
  static final PROYECTOS = amplify_core.QueryField(
    fieldName: "proyectos",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RelGrupoIotProyecto'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "GrupoIot";
    modelSchemaDefinition.pluralName = "GrupoIots";
    
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
      amplify_core.ModelIndex(fields: const ["nombre"], name: "byNombre")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GrupoIot.NOMBRE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GrupoIot.DESCRIPCION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GrupoIot.ESTADO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GrupoIot.USUARIOCREADOR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GrupoIot.OBSERVACIONES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GrupoIot.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GrupoIot.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: GrupoIot.DISPOSITIVOS,
      isRequired: false,
      ofModelName: 'RelDispositivoGrupoIot',
      associatedKey: RelDispositivoGrupoIot.GRUPO
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: GrupoIot.PROYECTOS,
      isRequired: false,
      ofModelName: 'RelGrupoIotProyecto',
      associatedKey: RelGrupoIotProyecto.GRUPO
    ));
  });
}

class _GrupoIotModelType extends amplify_core.ModelType<GrupoIot> {
  const _GrupoIotModelType();
  
  @override
  GrupoIot fromJson(Map<String, dynamic> jsonData) {
    return GrupoIot.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'GrupoIot';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [GrupoIot] in your schema.
 */
class GrupoIotModelIdentifier implements amplify_core.ModelIdentifier<GrupoIot> {
  final String id;

  /** Create an instance of GrupoIotModelIdentifier using [id] the primary key. */
  const GrupoIotModelIdentifier({
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
  String toString() => 'GrupoIotModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GrupoIotModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}