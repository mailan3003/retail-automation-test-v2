Given a key (e.g., Product_Not_Exists), search the .resx file for a <data> element where the name attribute matches the key. 
Then, extract the text inside the <value> tag of that element. This is the expected result.
For Example:
- Input key: Product_Not_Exists
- In the .resx file:
    `<data name="Product_Not_Exists" xml:space="preserve">
        <value>Sản phẩm {0} không tồn tại</value>
    </data>`
- Expected Output: Sản phẩm {0} không tồn tại

**Notice**
- All KVMessage exception keys are stored in the KVMessage.resx file which is located in the Resources\Kiotviet.Resources folder. For example:
    - Given key: KVMessage.NotFound
    - You should search their value in the Resources\Kiotviet.Resources\KVMessage.resx file
- All Label keys are stored in the Labels.resx file which is located in the Resources\Kiotviet.Resources folder. For example:
    - Given key: Labels.invoice_Paging
    - You should search their value in the Resources\Kiotviet.Resources\Labels.resx file

