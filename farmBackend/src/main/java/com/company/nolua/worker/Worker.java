package com.company.nolua.worker;

import com.company.nolua.pickable.Pickable;

public class Worker {

	public static class Position {
		private Integer row;
		private Integer col;

		public Position(Integer row, Integer col) {
			this.row = row;
			this.col = col;
		}

		public Integer getRow() {
			return row;
		}

		public Integer getCol() {
			return col;
		}
	}

	private String id;
	private Pickable hand;
	private Position position;

	public Worker(String id, Pickable hand, Position position) {
		this.id = id;
		this.hand = hand;
		this.position = position;
	}

	public String getId() {
		return id;
	}

	public Pickable getHand() {
		return hand;
	}

	public Position getPosition() {
		return position;
	}
}
