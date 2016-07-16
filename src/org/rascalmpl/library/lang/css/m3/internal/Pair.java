package org.rascalmpl.library.lang.css.m3.internal;

public class Pair<T, U> {
	private final T key;
	private final U value;

	public Pair(T key, U value) {
		this.key = key;
		this.value = value;
	}

	public T getKey() {
		return key;
	}

	public U getValue() {
		return value;
	}

}