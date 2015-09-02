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

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * @author  Kyle Stiemann
 */
/* package-private */ class GeneratorUtil {

	/* package-private */ static String getNodeContents(String nodeName, Node parentNode) {

		String nodeContents = null;
		NodeList childNodes = parentNode.getChildNodes();
		int totalChildNodes = childNodes.getLength();

		for (int i = 0; i < totalChildNodes; i++) {

			Node childNode = childNodes.item(i);
			nodeContents = getNodeContents(nodeName, childNode);

			if (nodeContents != null) {
				break;
			}

			String childNodeName = childNode.getNodeName();

			if (nodeName.equals(childNodeName)) {

				nodeContents = childNode.getTextContent();
				nodeContents = nodeContents.trim();

				break;
			}
		}

		return nodeContents;
	}
}
