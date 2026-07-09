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


/** This is an auto generated class representing the UserModelPackage type in your schema. */
class UserModelPackage extends amplify_core.Model {
  static const classType = const _UserModelPackageModelType();
  final String id;
  final ModelPackage? _modelPackage;
  final User? _user;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelPackageModelIdentifier get modelIdentifier {
      return UserModelPackageModelIdentifier(
        id: id
      );
  }
  
  ModelPackage? get modelPackage {
    return _modelPackage;
  }
  
  User? get user {
    return _user;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserModelPackage._internal({required this.id, modelPackage, user, createdAt, updatedAt}): _modelPackage = modelPackage, _user = user, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserModelPackage({String? id, ModelPackage? modelPackage, User? user}) {
    return UserModelPackage._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      modelPackage: modelPackage,
      user: user);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserModelPackage &&
      id == other.id &&
      _modelPackage == other._modelPackage &&
      _user == other._user;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserModelPackage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("modelPackage=" + (_modelPackage != null ? _modelPackage!.toString() : "null") + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserModelPackage copyWith({ModelPackage? modelPackage, User? user}) {
    return UserModelPackage._internal(
      id: id,
      modelPackage: modelPackage ?? this.modelPackage,
      user: user ?? this.user);
  }
  
  UserModelPackage copyWithModelFieldValues({
    ModelFieldValue<ModelPackage?>? modelPackage,
    ModelFieldValue<User?>? user
  }) {
    return UserModelPackage._internal(
      id: id,
      modelPackage: modelPackage == null ? this.modelPackage : modelPackage.value,
      user: user == null ? this.user : user.value
    );
  }
  
  UserModelPackage.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _modelPackage = json['modelPackage'] != null
        ? json['modelPackage']['serializedData'] != null
          ? ModelPackage.fromJson(new Map<String, dynamic>.from(json['modelPackage']['serializedData']))
          : ModelPackage.fromJson(new Map<String, dynamic>.from(json['modelPackage']))
        : null,
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : User.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'modelPackage': _modelPackage?.toJson(), 'user': _user?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'modelPackage': _modelPackage,
    'user': _user,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserModelPackageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelPackageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final MODELPACKAGE = amplify_core.QueryField(
    fieldName: "modelPackage",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ModelPackage'));
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserModelPackage";
    modelSchemaDefinition.pluralName = "UserModelPackages";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: UserModelPackage.MODELPACKAGE,
      isRequired: false,
      targetNames: ['modelPackageUser_model_packagesId'],
      ofModelName: 'ModelPackage'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: UserModelPackage.USER,
      isRequired: false,
      targetNames: ['userUser_model_packagesId'],
      ofModelName: 'User'
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

class _UserModelPackageModelType extends amplify_core.ModelType<UserModelPackage> {
  const _UserModelPackageModelType();
  
  @override
  UserModelPackage fromJson(Map<String, dynamic> jsonData) {
    return UserModelPackage.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserModelPackage';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserModelPackage] in your schema.
 */
class UserModelPackageModelIdentifier implements amplify_core.ModelIdentifier<UserModelPackage> {
  final String id;

  /** Create an instance of UserModelPackageModelIdentifier using [id] the primary key. */
  const UserModelPackageModelIdentifier({
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
  String toString() => 'UserModelPackageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelPackageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}