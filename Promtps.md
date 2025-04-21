# Prompt Best Practices
- Provide detail context such as programing language, library, domain..
- Provide detail requirements extract logic from actual source code, don't provide best practice/common feature from the domain...
- Provide detail output format such as markdown and in Vietnamese
- Provide detail structure, pattern, template to generate data such as APITestDesign.md
- Ask AI to check if it miss somthing after the job done

# Prompts
## Prompt list all api endpoint from source code
(first attach api source code to copilot (@ProductApI) and then prompt)
Please don't hallucination, scan this file line by line and list all the api endoint

## Prompt list all logical paths for a method needs to test
- You are a senior .net developer, you have deep knowledge about Poin of Sale and ERP domain. Please don't hallucination, read the files line by line, follow every execution path deeply to completly understand the whole logic of method CreateInvoice. Then please list out all logical path in that method. You must not miss even 1 path since it will be a serious problem.

- You are a senior .net developer, you have deep knowledge about Poin of Sale and ERP domain. Please don't hallucination, start from the method CreateInvoice, follow every execution path (deeply nested to other methods, file) and give all the methods and files included to the CreateInvoiceDependencies.md

## Prompt summary logic doc
- You are senior .net developer and have deep knowledge about Point Of Sale System. Don't hallucinated, please review the actual code line by line and help me list all the business logic of CreateInvoice methods to a markdown file in vietnamese. Don't imagine or grab the common features in the domain. The logic you list out must found in the actual code

## Add more logic  for each section
- Can you please check the actual code the whole file,follow every execution path (nestedly into other files, methods) to add all detail logic for section "1.1" (don't be hallucinated). Don't update the file, just give me the detail content in markdown format and should be explained in Vietnamese, don't include source code just explain the logic in natural language and domain terms

## Add more detail description for logic
- Can you please elaborate more about the items in section 1.8 "Xác thực lô/hạn sử dụng" by read the actual code line by line (don't be hallucinated) and keep others section intact



# Prompt generate test cases
Please looks at the files, don't hallucination and read the files throughout, and help me write robot framwork test case for the selected code that
- cover all branching logic
- validate response data and input data
- test specification is in gherkin format (given when then)
- using the api endpoint https://api-man.kvpos.com:8443 to call api

# Prompt implement test cases
You are a senior .net developer and master robot framework, gherkin language, you have deep knowledge about Poin of Sale and ERP domain. Please don't hallucination,generate all api test cases for section 1 "Kiểm tra và xác thực đầu vào" without using mock
- Completed source code that runable
- Don't be lazy, miss one case is a serious problem
- Test specification simple don't use code such as If Else 
- Must strictly follow the example and best practices and templates in the "Readme" file
- Do not call api to setup test data or validate test result
- Look into CommonData.robot file to reused existed common test data and create test case specific test data in new file
- Please write the test case in Vietnamese
- When you finish, check the result your self to see if you miss something and do it for the missed ones
- using the api endpoint https://api-man.kvpos.com:8443 to call api

You are a senior .net developer and master robot framework, gherkin language, you have deep knowledge about Poin of Sale and ERP domain. Please don't hallucination,generate all api test cases for section 1 "Kiểm Tra Và Xác Thực Đầu Vào" that
- Don't be lazy, miss one case is a serious problem
- Must strictly follow the example and best practices and templates in the APITestDesign.md file
- Do not call api to setup test data or validate test result
- Verify expected data is insert/updated in the database
- Look into CommonData.robot file to reused existed common test data and Env.robot for common variable, Utilities folder to reuse Keywords
- Use pattern init standard data and create more test case data derived from the standard data for simple data management
- Please write the test case and keywords in Vietnamese
- Test case description must have describe the test logic with example data

You are a senior .net developer and master robot framework, gherkin language, you have deep knowledge about Poin of Sale and ERP domain. Please don't hallucination,generate all api test cases for section "**Đánh giá khuyến mãi, voucher và điểm thưởng**" in the @CreateInvoiceAPILogic_Restructured.md  for CreateInvoice method of the @InvoiceApi.cs  that
- Don't be lazy, miss one case is a serious problem. 
- Follow the @APIStructure.md  file to understand how API strtucture to read code and generate test case with request body and SQL query for verification.
- Must strictly all rules, best practices, example in @APITestDesign.md file

# Prompt update test data file to use common data
- Please follow the rule in @APITestDesign.md to reuse common data. 
- Please check for undefined variable in this file and search it in @CommonData.robot . If you don't find it please use mcp to create a new record for it in the database and get back its value and use to define it in CommonData.robot


# Prompts add more test case
You are a senior .net developer and master robot framework, gherkin language, you have deep knowledge about Poin of Sale and ERP domain. Please don't hallucination,generate all api test cases for section "**Xử lý thanh toán**" in @CreateInvoiceAPILogic_Restructured.md  for CreateInvoice method of the @InvoiceApi.cs  that
- Don't be lazy, miss one case is a serious problem.  
- Please compare with @PromotionTest.robot  for curent test cases, look detail in the actual code @InvoiceApi.cs  and edit the @PromotionTest.robot  to add more test cases, test data and keywords 
- Don't create new file or modify/remove the current test case, reuse current keywords, test data and only append the new ones at the end of its file
- Follow the @APIStructure.md  file to understand how API strtucture to read code and generate test case with request body and SQL query for verification. 
- Add a tag AIGenerated to the test new case
- Must strictly all rules, best practices, example in @APITestDesign.md file
- 