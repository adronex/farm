package com.company.nolua.inventory;

public class InventoryItem {
	private String id;
	private InventoryItemType type;
	private Integer count;

	public InventoryItem(String id, InventoryItemType type, Integer count) {
		this.id = id;
		this.type = type;
		this.count = count;
	}

	public String getId() {
		return id;
	}

	public InventoryItemType getType() {
		return type;
	}

	public Integer getCount() {
		return count;
	}
}
