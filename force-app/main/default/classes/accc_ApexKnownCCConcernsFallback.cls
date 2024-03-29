/**
 * Copyright (c) 2016-2018, Bill Anderson All rights reserved.
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
 *   * Neither the name of Bill Andersonnor Bill Anderson nor the names of its
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
 * @description map the custom field name to the interface, and the name to a concrete class
 *
 * Note: these values may find themselves put into a Custom MDT. However, it will not impair/inhibit
 * future use as this is internal.
 *
 * To Added New Resouce classes  :Step 4a: Ensure Fallback Resources have the Resource Name ( i.e. LogFormatter)
 *                                Step 4b: Do not forget about 'accc_ApexTestJSONDataFallback'
 *
 *
 * @group Fallback Resources
 */
public without sharing class accc_ApexKnownCCConcernsFallback extends accc_ApexBaseFallback {

    ////////////////////////////////////////////////////////////////////////////////
    /// Data Members
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * Define the fallback resources, we want (JSON)
     */
    private static final String CrossCuttingConcernsFallback = '{' +
            //
            // Cross-Cutting resources (interfaces)
            //
            '"' + accc_ApexConstants.CategoryInterface_s + '":' +
            '{' +
            '"' + accc_ApexConstants.ConfigurationResource + '": "accc_IConfigurationProvider",' +
            '"' + accc_ApexConstants.LoggerResource + '": "accc_ILogger",' +
            '"' + accc_ApexConstants.LogFormatter + '": "accc_IDataFormat",' +
            '"' + accc_ApexConstants.ExceptionHandler + '": "accc_IApexExceptionHandler",' +
            '"' + accc_ApexConstants.ExceptionFormatter + '": "accc_IDataFormat",' +
            '"' + accc_ApexConstants.ExceptionPolicyHandler + '": "accc_IApexExceptionPolicyStrategy",' +
            '"' + accc_ApexConstants.PreviousTransactionResultResource + '": "accc_IPreviousTransactionResult",' +
            '"' + accc_ApexConstants.FactoryResource + '": "accc_IApexFactory",' +
            '"' + accc_ApexConstants.FallbackResource + '": "accc_IFallbackResources",' +
            '"' + accc_ApexConstants.RuntimeEnvironment + '": "accc_IApexRunEnvironment"'  +
            '},' +
            //
            // Cross-Cutting resources (implementation)
            //

            '"' + accc_ApexConstants.CategoryConcrete_s + '":' +
            '{' +
            '"' + accc_ApexConstants.ConfigurationResource + '": "accc_VirtualCustomSettings",' +
            '"' + accc_ApexConstants.LoggerResource + '": "accc_ApexObjectLogger",' +
            '"' + accc_ApexConstants.LogFormatter + '": "accc_ApexLogFormatter",' +
            '"' + accc_ApexConstants.ExceptionHandler + '": "accc_ApexExceptionHandler",' +
            '"' + accc_ApexConstants.ExceptionFormatter + '": "accc_ExceptionFormatter",' +
            '"' + accc_ApexConstants.ExceptionPolicyHandler + '": "accc_ApexExceptionPolicyStrategy",' +
            '"' + accc_ApexConstants.PreviousTransactionResultResource + '": "accc_ApexPreviousTransactionResult",' +
            '"' + accc_ApexConstants.FactoryResource + '": "accc_ApexObjectFactory",' +
            '"' + accc_ApexConstants.FallbackResource + '": "accc_ApexKnownCCConcernsFallback",' +
            '"' + accc_ApexConstants.RuntimeEnvironment + '": "accc_ApexBaseRuntimeEnvironment"'  +
            '},' +
            //
            // other cc resources
            //
            '"' + accc_ApexConstants.TriggersEnabled_r + '": "true",' +
            '"' + accc_ApexConstants.TraceFlagOn_r + '": "false",' +
            '"' + accc_ApexConstants.SoftAsserts_r + '": "false",' +
            '"' + accc_ApexConstants.TraceLogLevel_r + '": "debug",' +
            '"' + accc_ApexConstants.ShowCCTraceInfo_r + '": "false",' +
            '"' + accc_ApexConstants.EnvironmentClass_r + '": "accc_ApexRunEnvironmentSingleton",' +
            '"' + accc_ApexConstants.MaxChunkSize_r + '": "' + integer.valueOf(accc_ApexConstants.DEFAULT_MAX_NUMBER_OF_ITEMS_IN_CHUNK) + '"' +
            '}';

    ////////////////////////////////////////////////////////////////////////////////
    /// Ctor
    ////////////////////////////////////////////////////////////////////////////////

    /**
     * @description default ctor, set our known resources
     */
    public accc_ApexKnownCCConcernsFallback() {
        super(accc_ApexKnownCCConcernsFallback.CrossCuttingConcernsFallback);
    } // end of ctor
    /**
     * @description ctor , holds json data of resources
     *
     * @param String, json data of resources
     */
    public accc_ApexKnownCCConcernsFallback(String defaultValue) {
        super(defaultValue);
    } // end of ctor

} // end of accc_ApexKnownCCConcernsFallback