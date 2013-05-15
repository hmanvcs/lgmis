<?php

/**
 * Model for handcraft Information records 
 *
 */

class HandCraftInformation extends BaseEntity {

	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
				
		$this->setTableName('handcraftinformation');
		
		$this->hasColumn('commodityid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('locationid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('materialsource','string', 1000);
		$this->hasColumn('materialtype','string', 1000);
		$this->hasColumn('market','string', 1000);
		$this->hasColumn('creditsource','string', 1000);
		
		$this->hasColumn('startdate','date', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('enddate','date', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('quarter', 'string', 15, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('datecollected','date', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('collectedbyid', 'integer', null, array('notnull' => true, 'notblank' => true));
	} 
	
	/**
	 * Contructor method for custom functionality - add the fields to be marked as dates
	 */
	public function construct() {
		parent::construct();
		// define the date fields
		$this->addDateFields(array("startdate", "enddate", "datecollected"));
		// set the custom error messages
       	$this->addCustomErrorMessages(array(
       									"locationid.notblank" => $this->translate->_("handcraft_locationid_error"),
       									"commodityid.notblank" => $this->translate->_("handcraft_commodityid_error"),
       									"startdate.notblank" => $this->translate->_("handcraft_startdate_error"),
       									"enddate.notblank" => $this->translate->_("handcraft_enddate_error"),
       									"quarter.notblank" => $this->translate->_("handcraft_quarter_error"),
       									"datecollected.notblank" => $this->translate->_("handcraft_datecollected_error"),
       									"collectedbyid.notblank" => $this->translate->_("handcraft_collectedbyid_error")
       	       						));
	}
	
	public function setUp() {
		parent::setUp(); 
		
		$this->hasOne('District as location',
						 array(
								'local' => 'locationid',
								'foreign' => 'id'
							)
					); 
		$this->hasOne('Commodity as commodity',
						 array(
								'local' => 'commodityid',
								'foreign' => 'id'
							)
					); 
		$this->hasOne('UserAccount as collectedby',
						 array(
								'local' => 'collectedbyid',
								'foreign' => 'id'
							)
					);
	} 
	
}

?>