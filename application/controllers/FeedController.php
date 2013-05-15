<?php

class FeedController extends IndexController  {

    function indexAction() {
    	// disable rendering of the view and layout 
	    $this->_helper->layout->disableLayout();
	    $this->_helper->viewRenderer->setNoRender(TRUE);
	    
    	// $session = SessionWrapper::getInstance();
    	// debugMessage($this->_getAllParams());
    	
    	$conn = Doctrine_Manager::connection(); 
    	$query = "SELECT 
								d.datecollected as date, 
								REPLACE(d2.name,' Market','')as market,
								c.name as commodity,
								cu.name as unit,
								d.retailprice AS retailprice, 
								d.wholesaleprice AS wholesaleprice
								FROM commoditypricedetails AS d 
								INNER JOIN commodity AS c ON (d.`commodityid` = c.id)
								LEFT JOIN commodityunit AS cu ON (c.unitid = cu.id)
								INNER JOIN (
								SELECT cp.sourceid, 
								MAX(cp.datecollected) AS datecollected, 
								p.name FROM commoditypricedetails cp 
								INNER JOIN commoditypricesubmission AS cs1 ON (cp.`submissionid` = cs1.`id` 
								AND cs1.`status` = 'Approved') 
								INNER JOIN pricesource AS p ON (cp.sourceid = p.id AND p.`applicationtype` = 0 )
								WHERE cp.`pricecategoryid` = 2 GROUP BY cp.sourceid) AS d2 
								ON (d.`sourceid` = d2.sourceid AND d.`datecollected` = d2.datecollected) 
								WHERE d.`pricecategoryid` = 2 AND d.retailprice > 0 AND d.wholesaleprice > 0 ORDER BY d2.name";
    	
    	//debugMessage($query);
    	$result = $conn->fetchAll($query);
    	//debugMessage($result);
    	
    	$rssfeed = '<?xml version="1.0" encoding="UTF-8"?>';
	    $rssfeed .= '<rss version="2.0">';
	    $rssfeed .= '<channel>';
	    $rssfeed .= '<title>Latest Prices - '.date("F j, Y g:i a").'</title>';
	    $rssfeed .= '<link>http://infotradeuganda.com/feed/</link>';
	    $rssfeed .= '<description>The latest retail and wholesale prices for commodities in Uganda provided by infotradeuganda.com</description>';
	    $rssfeed .= '<language>en-us</language>';
	    $rssfeed .= '<copyright>Copyright (C) 2010 infotradeuganda.com</copyright>';
	    
	    foreach ($result as $line){
	    	$rssfeed .= '<item>';
	    	$rssfeed .= '<market>' .$line['market']. '</market>';
	    	$rssfeed .= '<product>' .$line['commodity']. '</product>';
	    	$rssfeed .= '<unit>' .$line['unit']. '</unit>';
	    	$rssfeed .= '<date>' .$line['date']. '</date>';
	    	$rssfeed .= '<retailPrice>' .$line['retailprice']. '</retailPrice>';
		    $rssfeed .= '<wholesalePrice>' .$line['wholesaleprice']. '</wholesalePrice>';
		    $rssfeed .= '</item>';
	    }
	    
	    $rssfeed .= '</channel>';
	    $rssfeed .= '</rss>';
	    echo $rssfeed;
    }
}

