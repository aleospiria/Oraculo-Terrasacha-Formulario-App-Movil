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


/** This is an auto generated class representing the TemplateFeature type in your schema. */
class TemplateFeature extends amplify_core.Model {
  static const classType = const _TemplateFeatureModelType();
  final String id;
  final Template? _template;
  final Feature? _feature;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TemplateFeatureModelIdentifier get modelIdentifier {
      return TemplateFeatureModelIdentifier(
        id: id
      );
  }
  
  Template? get template {
    return _template;
  }
  
  Feature? get feature {
    return _feature;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const TemplateFeature._internal({required this.id, template, feature, createdAt, updatedAt}): _template = template, _feature = feature, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory TemplateFeature({String? id, Template? template, Feature? feature}) {
    return TemplateFeature._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      template: template,
      feature: feature);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TemplateFeature &&
      id == other.id &&
      _template == other._template &&
      _feature == other._feature;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("TemplateFeature {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("template=" + (_template != null ? _template!.toString() : "null") + ", ");
    buffer.write("feature=" + (_feature != null ? _feature!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  TemplateFeature copyWith({Template? template, Feature? feature}) {
    return TemplateFeature._internal(
      id: id,
      template: template ?? this.template,
      feature: feature ?? this.feature);
  }
  
  TemplateFeature copyWithModelFieldValues({
    ModelFieldValue<Template?>? template,
    ModelFieldValue<Feature?>? feature
  }) {
    return TemplateFeature._internal(
      id: id,
      template: template == null ? this.template : template.value,
      feature: feature == null ? this.feature : feature.value
    );
  }
  
  TemplateFeature.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _template = json['template'] != null
        ? json['template']['serializedData'] != null
          ? Template.fromJson(new Map<String, dynamic>.from(json['template']['serializedData']))
          : Template.fromJson(new Map<String, dynamic>.from(json['template']))
        : null,
      _feature = json['feature'] != null
        ? json['feature']['serializedData'] != null
          ? Feature.fromJson(new Map<String, dynamic>.from(json['feature']['serializedData']))
          : Feature.fromJson(new Map<String, dynamic>.from(json['feature']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'template': _template?.toJson(), 'feature': _feature?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'template': _template,
    'feature': _feature,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TemplateFeatureModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TemplateFeatureModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TEMPLATE = amplify_core.QueryField(
    fieldName: "template",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Template'));
  static final FEATURE = amplify_core.QueryField(
    fieldName: "feature",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Feature'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TemplateFeature";
    modelSchemaDefinition.pluralName = "TemplateFeatures";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: TemplateFeature.TEMPLATE,
      isRequired: false,
      targetNames: ['templateTemplateFeaturesId'],
      ofModelName: 'Template'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: TemplateFeature.FEATURE,
      isRequired: false,
      targetNames: ['featureTemplateFeaturesId'],
      ofModelName: 'Feature'
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

class _TemplateFeatureModelType extends amplify_core.ModelType<TemplateFeature> {
  const _TemplateFeatureModelType();
  
  @override
  TemplateFeature fromJson(Map<String, dynamic> jsonData) {
    return TemplateFeature.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'TemplateFeature';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [TemplateFeature] in your schema.
 */
class TemplateFeatureModelIdentifier implements amplify_core.ModelIdentifier<TemplateFeature> {
  final String id;

  /** Create an instance of TemplateFeatureModelIdentifier using [id] the primary key. */
  const TemplateFeatureModelIdentifier({
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
  String toString() => 'TemplateFeatureModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TemplateFeatureModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}