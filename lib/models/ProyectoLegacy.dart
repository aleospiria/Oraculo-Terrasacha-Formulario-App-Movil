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


/** This is an auto generated class representing the ProyectoLegacy type in your schema. */
class ProyectoLegacy extends amplify_core.Model {
  static const classType = const _ProyectoLegacyModelType();
  final String id;
  final String? _projectId;
  final String? _descripcion;
  final List<ConsultaWeb>? _consultasWeb;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ProyectoLegacyModelIdentifier get modelIdentifier {
      return ProyectoLegacyModelIdentifier(
        id: id
      );
  }
  
  String get projectId {
    try {
      return _projectId!;
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
  
  List<ConsultaWeb>? get consultasWeb {
    return _consultasWeb;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ProyectoLegacy._internal({required this.id, required projectId, descripcion, consultasWeb, createdAt, updatedAt}): _projectId = projectId, _descripcion = descripcion, _consultasWeb = consultasWeb, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ProyectoLegacy({String? id, required String projectId, String? descripcion, List<ConsultaWeb>? consultasWeb}) {
    return ProyectoLegacy._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      projectId: projectId,
      descripcion: descripcion,
      consultasWeb: consultasWeb != null ? List<ConsultaWeb>.unmodifiable(consultasWeb) : consultasWeb);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProyectoLegacy &&
      id == other.id &&
      _projectId == other._projectId &&
      _descripcion == other._descripcion &&
      DeepCollectionEquality().equals(_consultasWeb, other._consultasWeb);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ProyectoLegacy {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("projectId=" + "$_projectId" + ", ");
    buffer.write("descripcion=" + "$_descripcion" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ProyectoLegacy copyWith({String? projectId, String? descripcion, List<ConsultaWeb>? consultasWeb}) {
    return ProyectoLegacy._internal(
      id: id,
      projectId: projectId ?? this.projectId,
      descripcion: descripcion ?? this.descripcion,
      consultasWeb: consultasWeb ?? this.consultasWeb);
  }
  
  ProyectoLegacy copyWithModelFieldValues({
    ModelFieldValue<String>? projectId,
    ModelFieldValue<String?>? descripcion,
    ModelFieldValue<List<ConsultaWeb>?>? consultasWeb
  }) {
    return ProyectoLegacy._internal(
      id: id,
      projectId: projectId == null ? this.projectId : projectId.value,
      descripcion: descripcion == null ? this.descripcion : descripcion.value,
      consultasWeb: consultasWeb == null ? this.consultasWeb : consultasWeb.value
    );
  }
  
  ProyectoLegacy.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _projectId = json['projectId'],
      _descripcion = json['descripcion'],
      _consultasWeb = json['consultasWeb']  is Map
        ? (json['consultasWeb']['items'] is List
          ? (json['consultasWeb']['items'] as List)
              .where((e) => e != null)
              .map((e) => ConsultaWeb.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['consultasWeb'] is List
          ? (json['consultasWeb'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ConsultaWeb.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'projectId': _projectId, 'descripcion': _descripcion, 'consultasWeb': _consultasWeb?.map((ConsultaWeb? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'projectId': _projectId,
    'descripcion': _descripcion,
    'consultasWeb': _consultasWeb,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ProyectoLegacyModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ProyectoLegacyModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final PROJECTID = amplify_core.QueryField(fieldName: "projectId");
  static final DESCRIPCION = amplify_core.QueryField(fieldName: "descripcion");
  static final CONSULTASWEB = amplify_core.QueryField(
    fieldName: "consultasWeb",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConsultaWeb'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ProyectoLegacy";
    modelSchemaDefinition.pluralName = "ProyectoLegacies";
    
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
      amplify_core.ModelIndex(fields: const ["projectId"], name: "byProjectId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ProyectoLegacy.PROJECTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ProyectoLegacy.DESCRIPCION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ProyectoLegacy.CONSULTASWEB,
      isRequired: false,
      ofModelName: 'ConsultaWeb',
      associatedKey: ConsultaWeb.PROYECTO
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

class _ProyectoLegacyModelType extends amplify_core.ModelType<ProyectoLegacy> {
  const _ProyectoLegacyModelType();
  
  @override
  ProyectoLegacy fromJson(Map<String, dynamic> jsonData) {
    return ProyectoLegacy.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ProyectoLegacy';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ProyectoLegacy] in your schema.
 */
class ProyectoLegacyModelIdentifier implements amplify_core.ModelIdentifier<ProyectoLegacy> {
  final String id;

  /** Create an instance of ProyectoLegacyModelIdentifier using [id] the primary key. */
  const ProyectoLegacyModelIdentifier({
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
  String toString() => 'ProyectoLegacyModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ProyectoLegacyModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}