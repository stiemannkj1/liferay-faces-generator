<#include "./ComponentTemplateFunctions.ftl">
<#include "./ComponentRendererTemplateFunctions.ftl">
<#compress>
<#function get_alloy_ui_name attribute>
	<#local alloy_ui_name = attribute["name"] />
	<#if has_attribute_extension(attribute, "alloy-ui-name")>
		<#local alloy_ui_name = attribute["attribute-extension/alloy-ui-name"] />
	</#if>
	<#return alloy_ui_name /> 
</#function>

<#function get_alloy_ui_type attribute>
	<#if has_attribute_extension(attribute, "alloy-ui-type")>
		<#local alloy_ui_type = attribute["attribute-extension/alloy-ui-type"] />
	<#else>
		<#local alloy_ui_type = get_java_wrapper_type(attribute)?remove_beginning("java.lang.") />
		<#if alloy_ui_type != "Boolean" && alloy_ui_type != "Integer" && alloy_ui_type != "String" >
			<#local alloy_ui_type = "Object" />
		</#if>
	</#if>
	<#return alloy_ui_type />
</#function>

<#function is_alloy_ui attribute>
	<#return attribute["attribute-extension"][0]?? && (
		(attribute["attribute-extension/alloy-ui"][0]?? && attribute["attribute-extension/alloy-ui"] == "true") ||
		attribute["attribute-extension/alloy-ui-name"][0]?? || attribute["attribute-extension/alloy-ui-type"][0]??
	) />
</#function>
</#compress>
<@generate_copyright_header shortNamespace copyrightYear />
package ${get_component_package(tag["tag-name"])}.internal;
//J-

import java.io.IOException;
import java.util.Set;

import javax.annotation.Generated;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;

import ${get_renderer_parent_class(tag)};

import ${get_component_package(tag["tag-name"])}.${tag["tag-name"]?cap_first};


<#if authors??>
<@generate_authors authors />
</#if>
@Generated(value = "com.liferay.alloy.tools.builder.FacesBuilder")
public abstract class ${tag["tag-name"]?cap_first}RendererBase extends ${get_renderer_parent_class(tag)?keep_after_last(".")} {
	<#assign first = true>
	<#list tag["attribute"]?sort_by("name") as attribute>
	<#if !attribute_is(attribute, "inherited", false) || is_alloy_ui(attribute)>
	<#if first>

	// Protected Constants
	</#if>
	protected static final String ${get_constant_string(get_alloy_ui_name(attribute))} = "${get_alloy_ui_name(attribute)}";
	<#assign first = false>
	</#if>
	</#list>

	@Override
	public void encodeAlloyAttributes(FacesContext facesContext, ResponseWriter responseWriter, UIComponent uiComponent) throws IOException {

		${tag["tag-name"]?cap_first} ${tag["tag-name"]} = (${tag["tag-name"]?cap_first}) uiComponent;
		boolean first = true;
		<#list tag["attribute"]?sort_by("name") as attribute>
		<#if is_alloy_ui(attribute)>

		${get_java_wrapper_type(attribute)?remove_beginning("java.lang.")} ${get_java_safe_name(attribute["name"])} = ${tag["tag-name"]}.${get_getter_method_prefix(attribute)}${get_java_bean_property_name(attribute["name"])}();

		if (${get_java_safe_name(attribute["name"])} != null) {

			encode${get_alloy_ui_name(attribute)?cap_first}(responseWriter, ${tag["tag-name"]}, ${get_java_safe_name(attribute["name"])}, first);
			first = false;
		}
		</#if>
		</#list>

		encodeHiddenAttributes(facesContext, responseWriter, ${tag["tag-name"]}, first);
	}

	@Override
	public String getAlloyClassName(FacesContext facesContext, UIComponent uiComponent) {
		return "${get_tag_extension(tag, "alloy-ui-name", tag["tag-name"]?cap_first)}";
	}

	@Override
	protected Set<String> getModules(FacesContext facesContext, UIComponent uiComponent) {

		Set<String> modules = super.getModules(facesContext, uiComponent);
		modules.add("${get_tag_extension(tag, "alloy-ui-module")}");
		return modules;
	}
	<#list tag["attribute"]?sort_by("name") as attribute>
	<#if is_alloy_ui(attribute)>

	protected void encode${get_alloy_ui_name(attribute)?cap_first}(ResponseWriter responseWriter, ${tag["tag-name"]?cap_first} ${tag["tag-name"]}, ${get_java_wrapper_type(attribute)?remove_beginning("java.lang.")} ${get_java_safe_name(attribute["name"])}, boolean first) throws IOException {
		encode${get_alloy_ui_type(attribute)}(responseWriter, ${get_constant_string(get_alloy_ui_name(attribute))}, ${get_java_safe_name(attribute["name"])},<#if get_alloy_ui_type(attribute) == "ClientId"> ${tag["tag-name"]},</#if> first);
	}
	</#if>
	</#list>

	protected void encodeHiddenAttributes(FacesContext facesContext, ResponseWriter responseWriter, ${tag["tag-name"]?cap_first} ${tag["tag-name"]}, boolean first) throws IOException {
		// no-op
	}
<#if has_tag_extension(tag, "delegate-renderer-type")>

<@generate_delegate_getters tag />
</#if>
}
//J+
