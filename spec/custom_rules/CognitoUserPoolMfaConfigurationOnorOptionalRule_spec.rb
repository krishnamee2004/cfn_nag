require 'spec_helper'
require 'cfn-model'
require 'cfn-nag/custom_rules/CognitoUserPoolMfaConfigurationOnorOptionalRule'

describe CognitoUserPoolMfaConfigurationOnorOptionalRule do
  context "Cognito UserPool with MfaConfiguration set to 'ON' (Wrapped in quotes, i.e 'ON')." do
    it 'Returns an empty list' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_on_wrapped_in_quotes.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end

  context "Cognito UserPool with MfaConfiguration set to ON/On/on (NOT wrapped in quotes)." do
    it 'Returns offending logical resource ids' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_on_not_wrapped_in_quotes.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[CognitoUserPool2 CognitoUserPool3 CognitoUserPool4]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end
  #
  context "Cognito UserPool with MfaConfiguration set to 'On' or 'on' (Wrapped in quotes but NOT fully upper case)." do
    it 'Returns offending logical resource ids' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_on_wrapped_in_quotes_not_uppercase.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[CognitoUserPool1 CognitoUserPool2]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end

  context "Cognito UserPool with MfaConfiguration set to OFF/Off/off or 'OFF'/'Off'/'off' or
  (Wrapped/Not wrapped in quotes and/or NOT fully upper case)." do
    it 'Returns offending logical resource ids' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_off_all_variations.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[CognitoUserPool1
                                         CognitoUserPool2
                                         CognitoUserPool3
                                         CognitoUserPool4
                                         CognitoUserPool5
                                         CognitoUserPool6]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end

  context "Cognito UserPool with MfaConfiguration set to 'Optional'/'optional' (NOT uppercase)." do
    it 'Returns offending logical resource ids' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_optional_not_uppercase.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[CognitoUserPool1 CognitoUserPool2 CognitoUserPool3 CognitoUserPool4]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end

  context "Cognito UserPool with MfaConfiguration set to OPTIONAL/'OPTIONAL' (uppercase)." do
    it 'Returns an empty list' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_optional_uppercase.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end

  context "Cognito UserPool with MfaConfiguration set to OFF/Off/off or 'OFF'/'Off'/'off' or
  when referenced by parameter values (Wrapped/Not wrapped in quotes and/or NOT fully upper case)." do
    it 'Returns offending logical resource ids' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_violations_all_variations_with_param_refs.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[CognitoUserPool1
                                         CognitoUserPool2
                                         CognitoUserPool3
                                         CognitoUserPool4
                                         CognitoUserPool5
                                         CognitoUserPool6
                                         CognitoUserPool7
                                         CognitoUserPool8
                                         CognitoUserPool9
                                         CognitoUserPool10
                                         CognitoUserPool11
                                         CognitoUserPool12
                                         CognitoUserPool13]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end
  context "Cognito UserPool with MfaConfiguration with parameters references but no default values" do
    it 'Returns an empty list' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_parameter_refs_no_default_values.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end

  context "Cognito UserPool with MfaConfiguration set to OPTIONAL/'OPTIONAL' or 'ON' with parameter references (uppercase)." do
    it 'Returns an empty list' do
      cfn_model = CfnParser.new.parse read_test_template(
                                          'yaml/cognito/cognito_user_pool_mfa_configuration_on_optional_parameter_refs.yaml'
                                      )

      actual_logical_resource_ids = CognitoUserPoolMfaConfigurationOnorOptionalRule.new.audit_impl cfn_model
      expected_logical_resource_ids = %w[]

      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
    end
  end
end
