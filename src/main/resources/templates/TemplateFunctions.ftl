<#compress>
<#function get_component_package tag_name>
	<#local tag_name = tag_name?trim />
	<#return "com.liferay.faces.${shortNamespace}.component.${tag_name?lower_case}" />
</#function>

<#function get_unqualified_class_name qualified_class_name>
	<#return qualified_class_name?keep_after_last(qualified_class_name?keep_before("<")?keep_before_last(".") + ".") />
</#function>

<#function model_is model extension default model_type>
	<#local model_is = default /> 
	<#if model["${model_type}-extension"][0]?? && model["${model_type}-extension/${extension}"][0]??>
		<#local model_is = (model["${model_type}-extension/${extension}"] == "true") />
	</#if>
	<#return model_is />
</#function>

<#function remove_CDATA string_with_CDATA>
	<#return string_with_CDATA?trim?remove_beginning("<![CDATA[")?remove_ending("]]>") />
</#function>

<#function tag_is tag extension default>
	<#return model_is(tag, extension, default, "tag") />
</#function>
</#compress>