<#compress>
<#include "./TemplateFunctions.ftl" />

<#macro generate_authors authors>
/**
<#list authors?sort as author>
 * @author	${author}
</#list>
 */
</#macro>

<#macro generate_copyright_header shortNamespace copyrightYear>
<#-- TODO make license configurable in tags.xml file -->
<#if shortNamespace == "bridge" || shortNamespace == "portlet" || shortNamespace == "showcase">
/**
 * Copyright (c) 2000-${copyrightYear} Liferay, Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
<#else>
/**
 * Copyright (c) 2000-${copyrightYear} Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
</#if>
</#macro>

<#function attribute_is attribute extension_name default>
	<#return (get_attribute_extension(attribute, extension_name, default?c)?lower_case == "true") />
</#function>

<#-- If the class extends from a class with the same name, it must use the fully qualified name. -->
<#function get_extends_class_name fully_qualified_class_name current_class_name>
	<#local extends_class_name = get_unqualified_class_name(fully_qualified_class_name) />
	<#if extends_class_name == current_class_name>
		<#local extends_class_name = fully_qualified_class_name />
	</#if>
	<#return extends_class_name />
</#function>

<#function get_getter_method_prefix attribute>
	<#local getter_method_prefix = "get" />
	<#if get_attribute_type(attribute) == "boolean">
		<#local getter_method_prefix = "is" />
	</#if>
	<#return getter_method_prefix />
</#function>

<#function get_java_bean_property_name name>
	<#local java_bean_property_name = name?cap_first />
	<#--
		See section 8.8 (*Capitalization of inferred names.*) of the Java Beans Spec:
		http://download.oracle.com/otn-pub/jcp/7224-javabeans-1.01-fr-spec-oth-JSpec/beans.101.pdf
	-->
	<#--
		This if statement is supposed to detect if the first letter is lowercase and second is uppercase. Another
		(better) method for doing this would be name?matches("^[a-z][A-Z]"), however, that method seems to have a bug
		and does not match correctly
	-->
	<#if name?uncap_first == name && name?string[1..<2]?cap_first == name?string[1..<2]>
		<#local java_bean_property_name = name />
	</#if>
	<#return java_bean_property_name />
</#function>

<#-- Constant list of Java reserved words to be used in the get_java_safe_name function. -->
<#assign java_reserved_words = [
	"abstract",
	"assert",
	"boolean",
	"break",
	"byte",
	"case",
	"catch",
	"char",
	"class",
	"const",
	"continue",
	"default",
	"do",
	"double",
	"else",
	"enum",
	"extends",
	"final",
	"finally",
	"first",
	"float",
	"for",
	"goto",
	"if",
	"implements",
	"import",
	"instanceof",
	"int",
	"interface",
	"long",
	"native",
	"new",
	"package",
	"private",
	"protected",
	"public",
	"return",
	"short",
	"static",
	"strictfp",
	"super",
	"switch",
	"synchronized",
	"this",
	"throw",
	"throws",
	"transient",
	"try",
	"void",
	"volatile",
	"while"
] />

<#function get_java_safe_name string conflict_strings...>
	<#local safe_string = string />
	<#if java_reserved_words?seq_contains(string) || conflict_strings?seq_contains(string)>
		<#local safe_string = "${string}_" />
	</#if>
	<#return safe_string />
</#function>

<#function get_java_wrapper_type attribute>
	<#local type = remove_CDATA(get_attribute_type(attribute)) />
	<#if type == "int">
		<#local java_wrapper_type = "Integer" />
	<#elseif type?contains(".") || type?contains("[]")>
		<#local java_wrapper_type = type />
	<#else>
		<#local java_wrapper_type = type?cap_first />
	</#if>
	<#return java_wrapper_type />
</#function>

</#compress>