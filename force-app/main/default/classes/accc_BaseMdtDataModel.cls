/**
 * Copyright (c) 2016-2018, Bill Anderson.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Bill Anderson nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * @author Bill Anderson
 * @description Base class for our custom MDT data model (DAO)
 * @group Common Layer
 */
public abstract without sharing class accc_BaseMdtDataModel {

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Data Members
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    // exposing common names and labels for the CMDT
    // custom mdt name
    public static final String CUSTOM_MDT_NAME = 'DeveloperName';
    // custom mdt label
    public static final String CUSTOM_MDT_LABEL =  'Label';
    /**
     * @description data cache information - view representation , allows for changes
     * in the implementation (data representation) w/o affecting the consumption
     *
     */
    public virtual class BaseDataModelInformation {
        public String label;
        public String namespacePrefix;
        public String developerName;
    } // end of  BaseDataModelInformation
    /**
     * This enum is used to control the search parameters
     * (protected is NOT ALLOW!)
     */
    public enum accc_ControlPolicySearchEnum {
        byLabel,            // by label
        byName,             // by name
        byCategoryAndLabel, // by category
        byDomain            // by domain (account, contact, etc.) : future use

    } // end of accc_ControlPolicySearchEnum

    // for caching locally, stored in section 'accc_BaseMdtDataModel'
    @TestVisible
    static final accc_ApexLocalL1Cache l1Cache = new  accc_ApexLocalL1Cache('accc_BaseMdtDataModel');
    // acts as the category
    @TestVisible
    static final String CUSTOM_MDT_CATEGORY = 'Label';
    // custom mdt select fields for common custom mdt fields
    @TestVisible
    static final String CUSTOM_MDT_FIELDS = 'DeveloperName, Id, Label, MasterLabel, NamespacePrefix, QualifiedApiName';
    // the selected fields query
    @TestVisible
    static final String SELECT_FIELDS = accc_ApexConstants.SELECT_s + CUSTOM_MDT_FIELDS;
    // category field ( which could be environment , depends upon the child class)
    @TestVisible
    String m_categoryField = CUSTOM_MDT_CATEGORY;
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // Properties
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description the custom mdt name
     *
     * @param value the custom mdt name
     * @return the custom mdt name
     */
    public String CustomMDTName { get; private set;}

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // CTORS
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description ctor
     *
     */
    public accc_BaseMdtDataModel(String customMDT) {
        this(customMDT, null);
    } // end of ctor
    /**
     * @description ctor
     *
     */
    public accc_BaseMdtDataModel(String customMDT, String category) {
        if ( string.isBlank(customMDT) ) {
            throw new accc_ApexApplicationException('accc_BaseMdtDataModel Exception ctor -- Bad Value, empty of null not allowed');
        }
        this.CustomMDTName = customMDT;
        this.categoryField = !string.isBlank(category) ? category : CUSTOM_MDT_CATEGORY;

    } // end of ctor
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // PUBLIC METHODS
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description  find all items
     *
     * @return the list of informaiton
     */
    public List<BaseDataModelInformation> findAll() {
        return this.getInformationByLookup(accc_ApexConstants.All_s, accc_ControlPolicySearchEnum.byLabel);
    } // end of findAll
    /**
    * @description find by category
    *
    * @param string the category / namespace
    * @return the model informaiton
    */
    public List<BaseDataModelInformation> findByCategory(String category) {
        return this.getInformationByLookup(category, null, accc_ControlPolicySearchEnum.byLabel);
    }// end of findByCategory
    /**
     * @description find by category and label
     *
     * @param string the category / namespace
     * @param string the label name
     * @return the model informaiton
     */
    public List<BaseDataModelInformation> findByCategoryAndLabel(String category, String labelName) {
        List<BaseDataModelInformation> result = null;
        // must have a valid name
        if ( !string.isBlank(labelName) ) {
            if ( string.isBlank(category)) {
                result = this.getInformationByLookup(labelName, accc_ControlPolicySearchEnum.byLabel);
            } else {
                result = this.getInformationByLookup(category, labelName, accc_ControlPolicySearchEnum.byLabel);
            }
        }
        return result;

    } // end of findByCategoryAndLabel
    /**
     * @description find by label
     *
     * @param labelName the label name
     * @return the  informaiton
     */
    public List<BaseDataModelInformation> findByLabel(String labelName) {
        return this.findByCategoryAndLabel(null, labelName);
    } // end of findByLabel

    /**
     * @description find by name
     *
     * @param labelName the  name
     * @return the informaiton
     */
    public List<BaseDataModelInformation> findByName(String name) {
        List<BaseDataModelInformation> result = null;
        if ( string.isBlank(name)) {
            return result;
        }
        return this.getInformationByLookup(name, accc_ControlPolicySearchEnum.byName);

    } // end of findByName

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // ***** ABSTRACT METHODS -- MUST BE OVERWRITTEN BY CHILD CLASS *****
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * @description child populates ALL data from the custom mdt
     *
     * @param mdt custom MDT
     * @return data representation of the custom metadata type
     */
    protected abstract List<BaseDataModelInformation> populateFromDataObjectChild(List<SObject> mdt);
    /**
     * @description allow the child to return their custom fields to select
     * @return collection of field name
     */
    protected abstract List<String> getSelectFields();
    /**
     * @description get the data object for testing from the child
     * @return the data object for testing
     */
    protected abstract BaseDataModelInformation getTestInformationByLookup();

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // PROTECTED PROPERTIES
    //
    /////////////////////////////////////////////////////////////////////////////////////////
    /**
     * the Category field (i.e. environment, but not always)
     */
    @TestVisible
    protected String  categoryField {
        get { return this.m_categoryField;}
        set {this.m_categoryField = value;}
    } // end of categoryField

    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // PROTECTED METHODS
    //
    /////////////////////////////////////////////////////////////////////////////////////////


    /**
     * @description find the custom mdt
     *
     * @param lookup lookup string
     * @param accc_ControlPolicySearchEnum how to search
     *
     * @return the data model
     */
    @TestVisible
    protected virtual List<BaseDataModelInformation> getInformationByLookup(String lookup, accc_ControlPolicySearchEnum controlType) {
        return this.getInformationByLookup(null, lookup, controlType);
    } // end of getInformationByLookup
    /**
     * @description get our query by string
     * @details get our query by string
     *
     * @param category/namespace
    *  @param lookup lookup string
     * @param controlType control of the query by
     * @return the query by string
     */
    @TestVisible
    protected virtual string getQueryBy( accc_ControlPolicySearchEnum controlType) {
        Boolean theControlType = controlType == accc_ControlPolicySearchEnum.byName;
        return theControlType ? CUSTOM_MDT_NAME : CUSTOM_MDT_LABEL;
    } // end of getQueryBy

    /**
    * @description find the custom mdt
    *
    * @param category/namespace
    * @param lookup lookup string
    * @param accc_ControlPolicySearchEnum how to search
    *
    * @return the data model
    */
    @TestVisible
    protected virtual List<BaseDataModelInformation> getInformationByLookup(String category, String lookup, accc_ControlPolicySearchEnum controlType) {

        string key = this.makeCacheKey(category, lookup);
        // check out local cache to save some time
        List<BaseDataModelInformation> result =  (List<BaseDataModelInformation>)l1Cache.get(key);
        try {

            // still no data?
            if ( result == null ) {
                List<SObject> cmdt = null;
                String selector = this.makeSoqlSelect();
                String theQueryType = this.getQueryBy(controlType);

                // preform query
                cmdt = this.queryCustomMDT(selector, theQueryType, lookup, category);

                // any data to process
                if ( cmdt != null && cmdt.size() > 0) {
                    result = this.populateFrom(cmdt);
                    // let child populate information and place in local cache
                    l1Cache.put(key, result);

                }
            }
        } catch (Exception excp) {
            // process exception
            accc_ApexEnvironment.getRuntimeEnvironment().exceptionHandler().process(excp, true);
        }

        return result;
    } // end of getInformationByLookup

    /**
     * @description populate DAO's values
     *
     * @param result DAO of the base
     * @param lbl mdt label
     * @param prefix namespace prefix
     * @param name developer name
     */
    @TestVisible
    protected void setValues(BaseDataModelInformation result, string lbl, string prefix, string name) {

        result.label = accc_ApexUtilities.normalizeString(lbl, accc_ApexConstants.MAX_STRING_SIZE);
        result.namespacePrefix = accc_ApexUtilities.normalizeString(prefix, accc_ApexConstants.MAX_STRING_SIZE);
        result.developerName = accc_ApexUtilities.normalizeString(name, accc_ApexConstants.MAX_STRING_SIZE);

    } // end of setValues
    /**
    * @description create the soql select clause
    * @return the select clause
    */
    @TestVisible
    protected String makeSoqlSelect() {
        String result =  SELECT_FIELDS;

        // when users inherit from the base, they may insert
        // an empty column which gets include in the soql params ( which we do not want)
        List<String> childList = this.getValidChildList(this.getSelectFields());

        if ( childList != null && childList.size() > 0) {
            result += accc_ApexConstants.CommaDelimiter + String.join( childList, accc_ApexConstants.CommaDelimiter);
        }
        return result;
    } // end of makeSoqlSelect
    /**
    * @description populate our external view of the data cache structure
    *
    * @param mdt the data cache Metadata
    * @return our view of the data ( allows us to change internally)
    */
    @TestVisible
    protected List<BaseDataModelInformation> populateFrom(List<SObject> mdt) {
        List<BaseDataModelInformation> result = null;
        if ( mdt != null ) {
            // call child's populate
            result = this.populateFromDataObjectChild(mdt);
        }
        return result;
    } // end of populateFrom

    /**
     * @description query for the Custom MDT
     *
     * @param selectClause the select clause
     * @param byValue the value (name or label)
     * @param theValue the actual value
     * @return the found SObject
     */
    @TestVisible
    protected List<SObject> queryCustomMDT(String selectClause,
                                           String byValue,
                                           String theValue,
                                           String category) {

        String myValue = theValue;
        String clause = selectClause + accc_ApexConstants.FROM_s + this.customMDTName;
        Boolean validCategory = !string.IsBlank(category) && category != accc_ApexConstants.All_s,
                validMyValue = !string.IsBlank(myValue) && myValue != accc_ApexConstants.All_s ;

        if ( !string.isBlank(selectClause) ) {

            if ( validMyValue ) {
                if ( validCategory ) {
                    clause +=  accc_ApexConstants.WHERE_s
                               + byValue + ' = :myValue '
                               + accc_ApexConstants.ANDString + ' '
                               +  this.categoryField  + ' = :category';
                } else {
                    clause +=  accc_ApexConstants.WHERE_s
                               + byValue + ' = :myValue ';
                }
            } else if ( validCategory ) {
                clause +=  accc_ApexConstants.WHERE_s
                           +  this.categoryField  + ' = :category';
            }

            // are we getting ALL items or not
        } else if (validMyValue ) {
            clause +=  accc_ApexConstants.WHERE_s
                       + byValue + ' = : myValue';
        }

        // get the results
        return Database.query(String.escapeSingleQuotes(clause));

    } // end of queryCustomMDT
    /**
    * @description make key for the cache
    *
    * @param category the category (debug, production, etc.)
    * @param lookup  how to find the value
    *
    * @return the key associate with the appropriate custom metadata
    */
    @TestVisible
    protected string makeCacheKey(string category, string lookup) {
        return accc_ApexUtilities.makeLocalCacheKey(this.CustomMDTName , accc_ApexUtilities.makeLocalCacheKey(category, lookup));
    } // end of makeCacheKey

    /**
    * @description get a valid soql parameter list from the child
    * @param incomingChildList incoming child list
    * @return valid soql parameter list from the child
    */
    @TestVisible
    protected  List<String>  getValidChildList(List<String> incomingChildList) {

        List<String> childList = incomingChildList;
        // when users inherit from the base, they may insert
        // an empty column which gets include in the soql params ( which we do not want)
        if ( childList != null && childList.size() > 0) {
            integer size = childList.size();
            // reconstitute the list, could use set but will not pick up  '\s+ '
            childList = new  List<String> () ;

            for ( integer inx = 0; inx < size; inx++ ) {
                if ( !string.IsBlank(incomingChildList[inx]) ) {
                    childList.add(incomingChildList[inx]);
                }


            }
        }
        return childList;
    } // end of getValidChildList
    /////////////////////////////////////////////////////////////////////////////////////////
    //
    // PRIVATE METHODS
    //
    /////////////////////////////////////////////////////////////////////////////////////////


} // end of accc_BaseMdtDataModel