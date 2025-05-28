Given a key (e.g., Product_Not_Exists), search the .resx file for a <data> element where the name attribute matches the key. 
Then, extract the text inside the <value> tag of that element. This is the expected result.
For Example:
- Input key: Product_Not_Exists
- In the .resx file:
    `<data name="Product_Not_Exists" xml:space="preserve">
        <value>Sản phẩm {0} không tồn tại</value>
    </data>`
- Expected Output: Sản phẩm {0} không tồn tại
