<#compress>
<#macro generate_delegate_getters tag>
	@Override
	public String getDelegateComponentFamily() {
		return ${get_tag_extension(tag, "delegate-component-family", "${tag[\"tag-name\"]?cap_first}.COMPONENT_FAMILY")};
	}

	@Override
	public String getDelegateRendererType() {
		return ${get_tag_extension(tag, "delegate-renderer-type")};
	}
</#macro>

<#macro generate_null_check_decode_method tag>
	@Override
	public void decode(FacesContext facesContext, UIComponent uiComponent) {

		super.decode(facesContext, uiComponent);

		UIInput uiInput = (UIInput) uiComponent;
		Object submittedValue = uiInput.getSubmittedValue();

		// FACES-3139 Avoid the possibility of a NullPointerException for custom components
		if (submittedValue == null) {
			uiInput.setSubmittedValue("");
		}
	}
</#macro>

<#function get_constant_string string>
	<#return string?replace("([A-Z]+)", "_$1", "r")?upper_case />
</#function>

<#function get_renderer_parent_class tag>
	<#return get_tag_extension(tag, "renderer-parent-class", "javax.faces.render.Renderer") />
</#function>

<#function is_alloy tag>
	<#return has_tag_extension(tag, "alloy-ui-modules") />
</#function>
</#compress>