<#include "./ComponentTemplateFunctions.ftl">
<#compress>
<#macro generate_javadoc attribute>
	/**
	 * @deprecated ${attribute["attribute-extension/deprecated"]}
	 */
</#macro>

<#macro generate_setter attribute tag>
	<#if attribute["attribute-extension/deprecated"][0]??>
	<@generate_javadoc attribute />
	@Deprecated
	</#if>
	<#if attribute_is(attribute, "override", false)>
	@Override
	</#if>
	public void set${get_java_bean_property_name(attribute["name"])}(${get_unprefixed_type(attribute)} ${get_java_safe_name(attribute["name"])}) {
		getStateHelper().put(${tag["tag-name"]?cap_first}PropertyKeys.${get_java_safe_name(attribute["name"])}, ${get_java_safe_name(attribute["name"])});
	}
</#macro>

<#assign default_parent_class = "javax.faces.component.UIComponentBase" />

<#function get_parent_class tag>
	<#return get_tag_extension(tag, "parent-class", "${default_parent_class}") />
</#function>

<#function get_unprefixed_type attribute>
	<#local type = get_attribute_type(attribute) />
	<#return remove_CDATA(type)?remove_beginning("java.lang.") />
</#function>

<#function has_attribute tag attribute_name>
	<#local has_attribute = false />
	<#list tag["attribute"] as attribute>
		<#if attribute["name"] == attribute_name>
			<#local has_attribute = true />
			<#break />
		</#if>
	</#list>
	<#return has_attribute />
</#function>

<#function has_default_parent_class tag>
	<#return get_parent_class(tag) == "${default_parent_class}" />
</#function>

<#function has_non_inherited_attribute tag attribute_name>
	<#local has_non_inherited_attribute = false />
	<#list tag["attribute"] as attribute>
		<#if attribute["name"] == attribute_name && !attribute_is(attribute, "inherited", false)>
			<#local has_non_inherited_attribute = true />
			<#break />
		</#if>
	</#list>
	<#return has_non_inherited_attribute />
</#function>
</#compress>
<@generate_copyright_header shortNamespace copyrightYear />
package ${get_component_package(tag["tag-name"])};
//J-

import javax.annotation.Generated;
<#-- If the class extends from a class with the same name, it must not import that class. -->
<#if get_unqualified_class_name(get_parent_class(tag)) != "${tag[\"tag-name\"]?cap_first}Base">
import ${get_parent_class(tag)?keep_before("<")};
</#if>
<#assign clientComponent = has_non_inherited_attribute(tag, "clientKey") />
<#assign styleable = has_attribute(tag, "style") && has_attribute(tag, "styleClass") />
<#if clientComponent || styleable>

<#if clientComponent>
import com.liferay.faces.util.component.ClientComponent;
</#if>
<#if styleable>
import com.liferay.faces.util.component.Styleable;
</#if>
</#if>


<#if authors??>
<@generate_authors authors />
</#if>
@Generated(value = "com.liferay.alloy.tools.builder.FacesBuilder")
public abstract class ${tag["tag-name"]?cap_first}Base extends ${get_extends_class_name(get_parent_class(tag), "${tag[\"tag-name\"]?cap_first}Base")}<#if clientComponent || styleable> implements<#if styleable> Styleable</#if><#if styleable && clientComponent>,</#if><#if clientComponent> ClientComponent</#if></#if> {

	// Public Constants
	<#if has_default_parent_class(tag)>
	public static final String COMPONENT_FAMILY = "${get_component_package(tag["tag-name"])}";
	</#if>
	public static final String COMPONENT_TYPE = "${get_component_package(tag["tag-name"])}.${tag["tag-name"]?cap_first}";
	<#if tag_is(tag, "generate-renderer", true)>
	public static final String RENDERER_TYPE = "${get_component_package(tag["tag-name"])}.${tag["tag-name"]?cap_first}Renderer";
	</#if>
	<#assign enumWritten = false>
	<#list tag["attribute"]?sort_by("name") as attribute>
	<#if !attribute_is(attribute, "inherited", false)>
	<#if !enumWritten>

	// Protected Enumerations
	protected enum ${tag["tag-name"]?cap_first}PropertyKeys {
		<#rt>${get_java_safe_name(attribute["name"])}
		<#assign enumWritten = true>
	<#else>
		<#lt>,
		<#rt>${get_java_safe_name(attribute["name"])}
	</#if>
	</#if>
	</#list>
	<#if enumWritten>

	}
	</#if>

	public ${tag["tag-name"]?cap_first}Base() {
		super();
		setRendererType(<#if tag_is(tag, "generate-renderer", true)>RENDERER_TYPE<#else>""</#if>);
	}
	<#if has_default_parent_class(tag)>

	@Override
	public String getFamily() {
		return COMPONENT_FAMILY;
	}
	</#if>
	<#list tag["attribute"]?sort_by("name") as attribute>
	<#if attribute["name"] == "label" && attribute_is(attribute, "default-to-component-label", false)>

	<#if has_attribute_extension(attribute, "deprecated")>
	<@generate_javadoc attribute />
	@Deprecated
	</#if>
	<#if attribute_is(attribute, "override", false) || attribute_is(attribute, "inherited", false)>
	@Override
	</#if>
	public String getLabel() {

		String label = <#if attribute_is(attribute, "inherited", false)>super.getLabel();<#else>(String) getStateHelper().eval(${tag["tag-name"]?cap_first}PropertyKeys.label, ${get_attribute_extension(attribute, "default-value", "null")});</#if>

		if (label == null) {

			javax.faces.context.FacesContext facesContext = javax.faces.context.FacesContext.getCurrentInstance();

			if (facesContext.getCurrentPhaseId() == javax.faces.event.PhaseId.PROCESS_VALIDATIONS) {
				label = com.liferay.faces.util.component.ComponentUtil.getComponentLabel(this);
			}
		}

		return label;
	}
	<#if !attribute_is(attribute, "inherited", false)>

	<@generate_setter attribute=attribute tag=tag />
	</#if>
	<#elseif attribute["name"] == "styleClass">

	<#if has_attribute_extension(attribute, "deprecated")>
	<@generate_javadoc attribute />
	@Deprecated
	</#if>
	<#if attribute_is(attribute, "override", false) || attribute_is(attribute, "inherited", false)>
	@Override
	</#if>
	public String getStyleClass() {

		// getStateHelper().eval(<#if !attribute_is(attribute, "inherited", false)>${tag["tag-name"]?cap_first}</#if>PropertyKeys.styleClass, null) is called because
		// super.getStyleClass() may return the styleClass name of the super class.
		String styleClass = (String) getStateHelper().eval(<#if !attribute_is(attribute, "inherited", false)>${tag["tag-name"]?cap_first}</#if>PropertyKeys.styleClass, ${get_attribute_extension(attribute, "default-value", "null")});

		return com.liferay.faces.util.component.ComponentUtil.concatCssClasses(styleClass, "${shortNamespace}-${tag["tag-name"]?replace("([A-Z]+)", "-$1", "r")?lower_case}"<#if has_tag_extension(tag, "extra-style-classes")>, "${tag["tag-extension/extra-style-classes"]}"</#if>);
	}
	<#if !attribute_is(attribute, "inherited", false)>

	<@generate_setter attribute=attribute tag=tag />
	</#if>
	<#elseif !attribute_is(attribute, "inherited", false)>

	<#if has_attribute_extension(attribute, "deprecated")>
	<@generate_javadoc attribute />
	@Deprecated
	</#if>
	<#if attribute_is(attribute, "override", false)>
	@Override
	</#if>
	<#if get_attribute_type(attribute)?contains("<")>
	@SuppressWarnings("unchecked")
	</#if>
	public ${get_unprefixed_type(attribute)} ${get_getter_method_prefix(attribute)}${get_java_bean_property_name(attribute["name"])}() {
		return (${get_java_wrapper_type(attribute)?remove_beginning("java.lang.")}) getStateHelper().eval(${tag["tag-name"]?cap_first}PropertyKeys.${get_java_safe_name(attribute["name"])}, ${get_attribute_extension(attribute, "default-value", "null")});
	}

	<@generate_setter attribute=attribute tag=tag />
	</#if>
	</#list>
}
//J+
