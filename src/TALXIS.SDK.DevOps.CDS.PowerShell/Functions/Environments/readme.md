Get-AdminPowerAppCdsDatabaseTemplates

LocationName: europe

TemplateName                  TemplateLocation TemplateDisplayName        IsDisable
                                                                                  d
------------                  ---------------- -------------------        ---------
D365_CDSSampleApp             europe           Sample App                     False
D365_Sales                    europe           Sales                           True
D365_DeveloperEdition         europe           Developer Edition              False
D365_CustomerService          europe           Customer Service                True
D365_FieldService             europe           Field Service                   True
D365_ProjectServiceAutomation europe           Project Service Automation      True
D365_SalesPro                 europe           Sales Pro                       True



Create-CDSEnvironment hokuspokus3 -Templates @("D365_Sales")