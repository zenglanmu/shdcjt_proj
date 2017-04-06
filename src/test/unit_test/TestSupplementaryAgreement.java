package test.unit_test;

import org.junit.Test;
import com.sap.mw.jco.JCO.Table;

public class TestSupplementaryAgreement
{

	@Test
	public void testSupplementaryAgreement()
	{
		Table table = new Table("ET_CO_CONT");
		table.setValue("DB_KEY", "123");
		table.setValue("DB_KEY", "232");
		System.out.println(table.getNumRows());
		for (int i = 0; i < table.getNumRows(); i++){
			table.setRow(i);
			System.out.println(table.getString("DB_KEY"));
		}
	}

}
