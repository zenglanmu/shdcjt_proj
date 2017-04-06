package test;

/**
 * ÁÐÊµÌå
 * 
 * @author Administrator
 * 
 */
public class Column {
	private String name;

	private String value;

	public Column(String name, String value) {
		super();
		this.name = name;
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return "ColumnInfo [name=" + name + ", value=" + value + "]";
	}

}
