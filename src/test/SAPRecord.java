package test;

import java.util.HashMap;
import java.util.Map;

import test.Column;

/**
 * Table表的一条记录
 * 
 * @author Administrator
 * 
 */
public class SAPRecord
{
	private Map<String, Column> columnMap = new HashMap<String, Column>();

	public SAPRecord()
	{
		super();
		// TODO Auto-generated constructor stub
	}

	public SAPRecord(Map<String, Column> columnMap)
	{
		super();
		this.columnMap = columnMap;
	}

	public Map<String, Column> getColumnMap()
	{
		return columnMap;
	}

	public void setColumnMap(Map<String, Column> columnMap)
	{
		this.columnMap = columnMap;
	}

	public void putKeyValue(String key, Column col)
	{
		if (!columnMap.containsKey(key))
		{
			columnMap.put(key, col);
		}
	}

	public String getValueByKey(String key)
	{
		Column col = new Column(key, "");
		if (columnMap.containsKey(key))
		{
			col = columnMap.get(key);
		}

		return col.getValue();
	}

	@Override
	public String toString()
	{
		return "SAPRecord [columnMap=" + columnMap + "]";
	}

}
