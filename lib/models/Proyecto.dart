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


/** This is an auto generated class representing the Proyecto type in your schema. */
class Proyecto extends amplify_core.Model {
  static const classType = const _ProyectoModelType();
  final String id;
  final String? _proyectoNombre;
  final String? _proyectoDescripcion;
  final String? _proyectoIdExterno;
  final bool? _proyectoActivo;
  final amplify_core.TemporalDateTime? _proyectoFechaCreacion;
  final amplify_core.TemporalDateTime? _proyectoFechaActualizacion;
  final List<ConsultaAnalisis>? _consultasAnalisis;
  final List<RelGrupoIotProyecto>? _gruposIot;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ProyectoModelIdentifier get modelIdentifier {
      return ProyectoModelIdentifier(
        id: id
      );
  }
  
  String get proyectoNombre {
    try {
      return _proyectoNombre!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get proyectoDescripcion {
    return _proyectoDescripcion;
  }
  
  String? get proyectoIdExterno {
    return _proyectoIdExterno;
  }
  
  bool get proyectoActivo {
    try {
      return _proyectoActivo!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get proyectoFechaCreacion {
    return _proyectoFechaCreacion;
  }
  
  amplify_core.TemporalDateTime? get proyectoFechaActualizacion {
    return _proyectoFechaActualizacion;
  }
  
  List<ConsultaAnalisis>? get consultasAnalisis {
    return _consultasAnalisis;
  }
  
  List<RelGrupoIotProyecto>? get gruposIot {
    return _gruposIot;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Proyecto._internal({required this.id, required proyectoNombre, proyectoDescripcion, proyectoIdExterno, required proyectoActivo, proyectoFechaCreacion, proyectoFechaActualizacion, consultasAnalisis, gruposIot, createdAt, updatedAt}): _proyectoNombre = proyectoNombre, _proyectoDescripcion = proyectoDescripcion, _proyectoIdExterno = proyectoIdExterno, _proyectoActivo = proyectoActivo, _proyectoFechaCreacion = proyectoFechaCreacion, _proyectoFechaActualizacion = proyectoFechaActualizacion, _consultasAnalisis = consultasAnalisis, _gruposIot = gruposIot, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Proyecto({String? id, required String proyectoNombre, String? proyectoDescripcion, String? proyectoIdExterno, required bool proyectoActivo, amplify_core.TemporalDateTime? proyectoFechaCreacion, amplify_core.TemporalDateTime? proyectoFechaActualizacion, List<ConsultaAnalisis>? consultasAnalisis, List<RelGrupoIotProyecto>? gruposIot}) {
    return Proyecto._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      proyectoNombre: proyectoNombre,
      proyectoDescripcion: proyectoDescripcion,
      proyectoIdExterno: proyectoIdExterno,
      proyectoActivo: proyectoActivo,
      proyectoFechaCreacion: proyectoFechaCreacion,
      proyectoFechaActualizacion: proyectoFechaActualizacion,
      consultasAnalisis: consultasAnalisis != null ? List<ConsultaAnalisis>.unmodifiable(consultasAnalisis) : consultasAnalisis,
      gruposIot: gruposIot != null ? List<RelGrupoIotProyecto>.unmodifiable(gruposIot) : gruposIot);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Proyecto &&
      id == other.id &&
      _proyectoNombre == other._proyectoNombre &&
      _proyectoDescripcion == other._proyectoDescripcion &&
      _proyectoIdExterno == other._proyectoIdExterno &&
      _proyectoActivo == other._proyectoActivo &&
      _proyectoFechaCreacion == other._proyectoFechaCreacion &&
      _proyectoFechaActualizacion == other._proyectoFechaActualizacion &&
      DeepCollectionEquality().equals(_consultasAnalisis, other._consultasAnalisis) &&
      DeepCollectionEquality().equals(_gruposIot, other._gruposIot);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Proyecto {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("proyectoNombre=" + "$_proyectoNombre" + ", ");
    buffer.write("proyectoDescripcion=" + "$_proyectoDescripcion" + ", ");
    buffer.write("proyectoIdExterno=" + "$_proyectoIdExterno" + ", ");
    buffer.write("proyectoActivo=" + (_proyectoActivo != null ? _proyectoActivo!.toString() : "null") + ", ");
    buffer.write("proyectoFechaCreacion=" + (_proyectoFechaCreacion != null ? _proyectoFechaCreacion!.format() : "null") + ", ");
    buffer.write("proyectoFechaActualizacion=" + (_proyectoFechaActualizacion != null ? _proyectoFechaActualizacion!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Proyecto copyWith({String? proyectoNombre, String? proyectoDescripcion, String? proyectoIdExterno, bool? proyectoActivo, amplify_core.TemporalDateTime? proyectoFechaCreacion, amplify_core.TemporalDateTime? proyectoFechaActualizacion, List<ConsultaAnalisis>? consultasAnalisis, List<RelGrupoIotProyecto>? gruposIot}) {
    return Proyecto._internal(
      id: id,
      proyectoNombre: proyectoNombre ?? this.proyectoNombre,
      proyectoDescripcion: proyectoDescripcion ?? this.proyectoDescripcion,
      proyectoIdExterno: proyectoIdExterno ?? this.proyectoIdExterno,
      proyectoActivo: proyectoActivo ?? this.proyectoActivo,
      proyectoFechaCreacion: proyectoFechaCreacion ?? this.proyectoFechaCreacion,
      proyectoFechaActualizacion: proyectoFechaActualizacion ?? this.proyectoFechaActualizacion,
      consultasAnalisis: consultasAnalisis ?? this.consultasAnalisis,
      gruposIot: gruposIot ?? this.gruposIot);
  }
  
  Proyecto copyWithModelFieldValues({
    ModelFieldValue<String>? proyectoNombre,
    ModelFieldValue<String?>? proyectoDescripcion,
    ModelFieldValue<String?>? proyectoIdExterno,
    ModelFieldValue<bool>? proyectoActivo,
    ModelFieldValue<amplify_core.TemporalDateTime?>? proyectoFechaCreacion,
    ModelFieldValue<amplify_core.TemporalDateTime?>? proyectoFechaActualizacion,
    ModelFieldValue<List<ConsultaAnalisis>?>? consultasAnalisis,
    ModelFieldValue<List<RelGrupoIotProyecto>?>? gruposIot
  }) {
    return Proyecto._internal(
      id: id,
      proyectoNombre: proyectoNombre == null ? this.proyectoNombre : proyectoNombre.value,
      proyectoDescripcion: proyectoDescripcion == null ? this.proyectoDescripcion : proyectoDescripcion.value,
      proyectoIdExterno: proyectoIdExterno == null ? this.proyectoIdExterno : proyectoIdExterno.value,
      proyectoActivo: proyectoActivo == null ? this.proyectoActivo : proyectoActivo.value,
      proyectoFechaCreacion: proyectoFechaCreacion == null ? this.proyectoFechaCreacion : proyectoFechaCreacion.value,
      proyectoFechaActualizacion: proyectoFechaActualizacion == null ? this.proyectoFechaActualizacion : proyectoFechaActualizacion.value,
      consultasAnalisis: consultasAnalisis == null ? this.consultasAnalisis : consultasAnalisis.value,
      gruposIot: gruposIot == null ? this.gruposIot : gruposIot.value
    );
  }
  
  Proyecto.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _proyectoNombre = json['proyectoNombre'],
      _proyectoDescripcion = json['proyectoDescripcion'],
      _proyectoIdExterno = json['proyectoIdExterno'],
      _proyectoActivo = json['proyectoActivo'],
      _proyectoFechaCreacion = json['proyectoFechaCreacion'] != null ? amplify_core.TemporalDateTime.fromString(json['proyectoFechaCreacion']) : null,
      _proyectoFechaActualizacion = json['proyectoFechaActualizacion'] != null ? amplify_core.TemporalDateTime.fromString(json['proyectoFechaActualizacion']) : null,
      _consultasAnalisis = json['consultasAnalisis']  is Map
        ? (json['consultasAnalisis']['items'] is List
          ? (json['consultasAnalisis']['items'] as List)
              .where((e) => e != null)
              .map((e) => ConsultaAnalisis.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['consultasAnalisis'] is List
          ? (json['consultasAnalisis'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ConsultaAnalisis.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _gruposIot = json['gruposIot']  is Map
        ? (json['gruposIot']['items'] is List
          ? (json['gruposIot']['items'] as List)
              .where((e) => e != null)
              .map((e) => RelGrupoIotProyecto.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['gruposIot'] is List
          ? (json['gruposIot'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => RelGrupoIotProyecto.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'proyectoNombre': _proyectoNombre, 'proyectoDescripcion': _proyectoDescripcion, 'proyectoIdExterno': _proyectoIdExterno, 'proyectoActivo': _proyectoActivo, 'proyectoFechaCreacion': _proyectoFechaCreacion?.format(), 'proyectoFechaActualizacion': _proyectoFechaActualizacion?.format(), 'consultasAnalisis': _consultasAnalisis?.map((ConsultaAnalisis? e) => e?.toJson()).toList(), 'gruposIot': _gruposIot?.map((RelGrupoIotProyecto? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'proyectoNombre': _proyectoNombre,
    'proyectoDescripcion': _proyectoDescripcion,
    'proyectoIdExterno': _proyectoIdExterno,
    'proyectoActivo': _proyectoActivo,
    'proyectoFechaCreacion': _proyectoFechaCreacion,
    'proyectoFechaActualizacion': _proyectoFechaActualizacion,
    'consultasAnalisis': _consultasAnalisis,
    'gruposIot': _gruposIot,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ProyectoModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ProyectoModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final PROYECTONOMBRE = amplify_core.QueryField(fieldName: "proyectoNombre");
  static final PROYECTODESCRIPCION = amplify_core.QueryField(fieldName: "proyectoDescripcion");
  static final PROYECTOIDEXTERNO = amplify_core.QueryField(fieldName: "proyectoIdExterno");
  static final PROYECTOACTIVO = amplify_core.QueryField(fieldName: "proyectoActivo");
  static final PROYECTOFECHACREACION = amplify_core.QueryField(fieldName: "proyectoFechaCreacion");
  static final PROYECTOFECHAACTUALIZACION = amplify_core.QueryField(fieldName: "proyectoFechaActualizacion");
  static final CONSULTASANALISIS = amplify_core.QueryField(
    fieldName: "consultasAnalisis",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConsultaAnalisis'));
  static final GRUPOSIOT = amplify_core.QueryField(
    fieldName: "gruposIot",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RelGrupoIotProyecto'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Proyecto";
    modelSchemaDefinition.pluralName = "Proyectos";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Proyecto.PROYECTONOMBRE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Proyecto.PROYECTODESCRIPCION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Proyecto.PROYECTOIDEXTERNO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Proyecto.PROYECTOACTIVO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Proyecto.PROYECTOFECHACREACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Proyecto.PROYECTOFECHAACTUALIZACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Proyecto.CONSULTASANALISIS,
      isRequired: false,
      ofModelName: 'ConsultaAnalisis',
      associatedKey: ConsultaAnalisis.PROYECTO
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Proyecto.GRUPOSIOT,
      isRequired: false,
      ofModelName: 'RelGrupoIotProyecto',
      associatedKey: RelGrupoIotProyecto.PROYECTO
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

class _ProyectoModelType extends amplify_core.ModelType<Proyecto> {
  const _ProyectoModelType();
  
  @override
  Proyecto fromJson(Map<String, dynamic> jsonData) {
    return Proyecto.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Proyecto';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Proyecto] in your schema.
 */
class ProyectoModelIdentifier implements amplify_core.ModelIdentifier<Proyecto> {
  final String id;

  /** Create an instance of ProyectoModelIdentifier using [id] the primary key. */
  const ProyectoModelIdentifier({
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
  String toString() => 'ProyectoModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ProyectoModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}