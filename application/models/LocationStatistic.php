<?php

/**
 * Model for statistics on locations (districts, counties, subcounties, parishes) 
 *
 */

class LocationStatistic extends BaseEntity {
	
	public function setTableDefinition() {
		#add the table definitions from the parent table
		parent::setTableDefinition();
		
		$this-> setTableName('locationstatistic');
		$this->hasColumn('locationid', 'integer', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('startdate', 'date', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('enddate', 'date', null, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('statisticid', 'integer', null);
		$this->hasColumn('unitid', 'integer', null); 
		$this->hasColumn('value', 'string', 50, array('notnull' => true, 'notblank' => true));
		$this->hasColumn('source', 'string', 255);
		$this->hasColumn('notes', 'string', 1000);
		$this->hasColumn('period', 'string', 15);
		$this->hasColumn('customstat', 'string', 50);
		$this->hasColumn('customunit', 'string', 50);
	}
	/**
	 * Contructor method for custom functionality - add the fields to be marked as dates
	 */
	public function construct() {
		parent::construct();
		// define the date fields
		$this->addDateFields(array("startdate", "enddate"));
		// set the custom error messages
       	$this->addCustomErrorMessages(array(
       									"locationid.notblank" => $this->translate->_("locationstatistic_locationid_error"),
       									"startdate.notblank" => $this->translate->_("locationstatistic_startdate_error"),
       									"enddate.notblank" => $this->translate->_("locationstatistic_enddate_error"),
       									"value.notblank" => $this->translate->_("locationstatistic_value_error")
       	       						));
	}
	
	public function setUp() {
		parent::setUp(); 
		
		// the location for which the details are being provided
		$this->hasOne('District as location',
						 array(
								'local' => 'locationid',
								'foreign' => 'id'
							)
					); 
		$this->hasOne('Statistic as statistic',
						 array(
								'local' => 'statisticid',
								'foreign' => 'id'
							)
					); 
		$this->hasOne('CommodityUnit as unit',
						 array(
								'local' => 'unitid',
								'foreign' => 'id'
							)
					); 
	}
	function processPost($formvalues){
		// check if the locationid is not specified and remove it from POST
		if (isArrayKeyAnEmptyString('unitid', $formvalues)) {
			$formvalues['unitid'] = NULL;
		}
		if (isArrayKeyAnEmptyString('statisticid', $formvalues)) {
			$formvalues['statisticid'] = NULL;
		}
		parent::processPost($formvalues);
	}
}

?>