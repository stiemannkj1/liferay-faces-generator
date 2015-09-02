/**
 * Copyright (c) 2000-2015 Liferay, Inc. All rights reserved.
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
package com.liferay.faces.generator;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import freemarker.ext.dom.NodeModel;


/**
 * @author  Kyle Stiemann
 */
/* package-private */ class Tag {

	private boolean generateJava = true;
	private boolean generateComponent = true;
	private boolean generateRenderer = true;
	private boolean generateTaglibXML = true;
	private String tagName;
	private NodeModel tagNodeModel;
	private Node tagNode;
	private Map<String, Node> attributeMap = new HashMap<String, Node>();
	private List<String> extendsTags = new ArrayList<String>();

	/* package-private */ Tag(Node tagNode) {

		this.tagNode = tagNode;

		NodeList childNodes = tagNode.getChildNodes();
		int totalChildNodes = childNodes.getLength();

		for (int i = 0; i < totalChildNodes; i++) {

			Node childNode = childNodes.item(i);
			String nodeName = childNode.getNodeName();

			if (nodeName.equals("tag-name")) {
				this.tagName = childNode.getTextContent();
			}
			else if (nodeName.equals("attribute")) {

				String attributeName = GeneratorUtil.getNodeContents("name", childNode);
				attributeMap.put(attributeName, childNode);
			}
			else if (nodeName.equals("tag-extension")) {

				String extendsTagsString = GeneratorUtil.getNodeContents("extends-tags", childNode);

				if ((extendsTagsString != null) && !extendsTagsString.equals("")) {
					String[] extendsTagsArray = extendsTagsString.split(" ");
					extendsTags.addAll(Arrays.asList(extendsTagsArray));
				}

				String generateJavaString = GeneratorUtil.getNodeContents("generate-java", childNode);
				generateJava = ((generateJavaString == null) || !generateJavaString.toLowerCase().equals("false"));

				String generateTaglibXMLString = GeneratorUtil.getNodeContents("generate-taglib-xml", childNode);
				generateTaglibXML = ((generateTaglibXMLString == null) ||
						!generateTaglibXMLString.toLowerCase().equals("false"));

				String generateComponentString = GeneratorUtil.getNodeContents("generate-component", childNode);
				generateComponent = ((generateComponentString == null) ||
						!generateComponentString.toLowerCase().equals("false"));

				String generateRendererString = GeneratorUtil.getNodeContents("generate-renderer", childNode);
				generateRenderer = ((generateRendererString == null) ||
						!generateRendererString.toLowerCase().equals("false"));
			}
		}
	}

	/* package-private */ void addExtendedComponentAttributes(Tag extendedTag, Document document, boolean inherited) {

		Map<String, Node> extendedTagAttributeMap = extendedTag.getAttributeMap();
		Set<Map.Entry<String, Node>> extendedTagAttributeMapEntrySet = extendedTagAttributeMap.entrySet();

		for (Map.Entry<String, Node> extendedTagAttributeEntry : extendedTagAttributeMapEntrySet) {

			String attributeName = extendedTagAttributeEntry.getKey();

			if (!attributeMap.containsKey(attributeName)) {

				Node attributeNode = extendedTagAttributeEntry.getValue();
				Node attributeNodeClone = attributeNode.cloneNode(true);
				document.adoptNode(attributeNodeClone);

				boolean inheritedNodeExists = GeneratorUtil.getNodeContents("inherited", attributeNodeClone) != null;

				if (inherited && !inheritedNodeExists) {
					setAttributeExtension(document, attributeNodeClone, "inherited", "true");
				}

				attributeMap.put(attributeName, attributeNodeClone);
				tagNode.appendChild(attributeNodeClone);
			}
		}
	}

	/* package-private */ void removeExtendsTags() {

		extendsTags.clear();

		NodeList childNodes = tagNode.getChildNodes();
		int totalChildNodes = childNodes.getLength();

		for (int i = 0; i < totalChildNodes; i++) {

			Node childNode = childNodes.item(i);
			String nodeName = childNode.getNodeName();

			if ("extends-tags".equals(nodeName)) {
				tagNode.removeChild(childNode);
			}
		}
	}

	/* package-private */ boolean isGenerateJava() {
		return generateJava;
	}

	private void setAttributeExtension(Document document, Node attribute, String name, String value) {

		Node attributeExtensionParentNode = null;
		NodeList childNodes = attribute.getChildNodes();
		int totalChildNodes = childNodes.getLength();

		for (int i = 0; i < totalChildNodes; i++) {

			Node childNode = childNodes.item(i);
			String childNodeName = childNode.getNodeName();

			if ("attribute-extension".equals(childNodeName)) {
				attributeExtensionParentNode = childNode;

				break;
			}
		}

		if (attributeExtensionParentNode == null) {

			attributeExtensionParentNode = document.createElement("attribute-extension");
			attribute.appendChild(attributeExtensionParentNode);
		}

		Node attributeExtensionNode = document.createElement(name);
		attributeExtensionNode.setTextContent(value);
		attributeExtensionParentNode.appendChild(attributeExtensionNode);
	}

	/* package-private */ Map<String, Node> getAttributeMap() {
		return Collections.unmodifiableMap(attributeMap);
	}

	/* package-private */ List<String> getExtendsTags() {
		return Collections.unmodifiableList(extendsTags);
	}

	/* package-private */ boolean isGenerateTaglibXML() {
		return generateTaglibXML;
	}

	/* package-private */ boolean isGenerateRenderer() {
		return generateRenderer;
	}

	/* package-private */ boolean isGenerateComponent() {
		return generateComponent;
	}

	/* package-private */ String getTagName() {
		return tagName;
	}

	/* package-private */ NodeModel getTagNodeModel() {

		if (tagNodeModel == null) {
			tagNodeModel = NodeModel.wrap(tagNode);
		}

		return tagNodeModel;
	}
}
