**Instructions to write efficient business logic:**
- Store all business logic files in the `retail-automation-test-v2/Logic` directory.
- Read the code in small chunks, one at a time (around 50 lines).
- Separate business logic into small files.
- Add an indexes file based on the following example:
```
1. [Kiểm tra thông tin khách hàng và xử lý thông tin giao hàng](./CreateInvoice-CustomerDelivery.md)
2. [Kiểm tra kho hàng](./CreateInvoice-WarehouseCheck.md)
3. [Lưu hoặc cập nhật hóa đơn](./CreateInvoice-SaveOrUpdateInvoice.md)
    - [Cập nhật hóa đơn hiện có](./CreateInvoice-UpdateExistingInvoice-Index.md)
      - [Kiểm tra vận đơn đang xử lý](./CheckProcessingShippingTasks.md)
      - [Xử lý tác vụ vận chuyển quá hạn](./ProcessExpiredShippingTasks.md)
      - [Cập nhật hóa đơn](./UpdateInvoice.md)
```
- Add navigators to next and previous file based on the following example:
```
    **Điều hướng**
    - Trước đó: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md)
    - Tiếp theo: [02-CreateInvoice-VerifyInitData.md](./02-CreateInvoice-VerifyInitData.md)
    - Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md)
```
- A good explanation should meet these criteria:
    - It must follow this structure:
      - Purpose
      - Main processes
      - Exception handling
      - Important notes
    - It should include the name of the method or a specific piece of code (not the entire source code). It helps developers find the actual code. For example:
    ```
    **Trích xuất và chuẩn bị dữ liệu ban đầu**:
    - Kiểm tra cấu hình thuế VAT thông qua `TaxService.IsActiveProductVATToggle()` và lưu kết quả vào biến `isUsingProductVAT`
    - Nếu không sử dụng VAT theo sản phẩm (`isUsingProductVAT = false`), hệ thống đặt `invoice.TotalTax = null`
    - Xác định ngành hàng: `isCoffee = CurrentIndustryId == (int)IndustryList.Coffee` để áp dụng các quy tắc xử lý đặc thù

    **Chuẩn hóa thông tin thời gian**:
    - Chuyển đổi thời gian từ UTC sang múi giờ địa phương:
        - `invoice.PurchaseDate = invoice.PurchaseDateUtc ?? invoice.PurchaseDate`
        - `invoice.ExpectedDelivery = invoice.ExpectedDeliveryUtc ?? invoice.ExpectedDelivery`
    - Nếu có thông tin giao hàng, cũng chuẩn hóa thời gian giao hàng dự kiến:
        - `invoice.DeliveryDetail.ExpectedDelivery = invoice.DeliveryDetail.ExpectedDeliveryUtc ?? invoice.DeliveryDetail.ExpectedDelivery`
    ```
    - It should include both the exception message keys and their values. See the details in the file: [HowToFindCorrectExceptionValue](./HowToFindCorrectExceptionValue.md). The main purpose is to make writing test cases easier.
    ```
    - **Kiểm tra tình trạng thuốc hết hạn**:
       - Quy tắc xác định thuốc đang bán:
         - Hệ thống lọc ra các thuốc không phải thuốc mới hoặc có thuốc thay thế
         - Công thức: `listSellMedicine = invoice.Medicines` loại trừ các thuốc có mã trùng với `invoice.NewMedicines` hoặc có `ReplaceMedicine != null`
       - Quy tắc kiểm tra hết hạn:
         - Với mỗi thuốc trong danh sách đang bán, kiểm tra thuộc tính `IsExpired`
         - Nếu `IsExpired == true`, thêm mã thuốc vào danh sách thuốc hết hạn
       - Kết quả: 
         - Nếu có ít nhất một thuốc hết hạn, hệ thống sẽ ném ngoại lệ `KVMedicineException`
         - Thông báo lỗi: Nếu chỉ có 1 thuốc hết hạn, hiển thị mã thuốc đó; nếu có nhiều thuốc, hiển thị danh sách mã thuốc ngăn cách bởi dấu phẩy
         - Nội dung thông báo: "[danh sách mã] đã bán hết số lượng trong đơn, vui lòng xóa sản phẩm để tạo đơn." (`KVMessage.Medicine_ProductCodeSoldOut`)
    ```
    - Most test cases starting with the prefix **When Gửi Yêu Cầu** make HTTP requests to the server to retrieve a response. Therefore, It should describe how to prepare test data as an HTTP request body to make test case creation easier. There are 2 cases are needed to consider:
        - If it is a parametter of a method that is invoked by the another method, let's review the original calling method to understand how to structure test data.
        - If it relies on other logic, let's review that logic to understand how to structure test data.
        - Finally, create a small section describing how to prepare test data for integration tests.
        For example:
          - If the current method invokes any other methods. Perform the following tasks carefully:
            - Explain it in new files following the same rules in this file.
            - Add a reference to the current explanation.
            - For example:
            ```
            ### 1. Lấy danh sách sản phẩm từ cơ sở dữ liệu
            - Trích xuất danh sách ID sản phẩm từ `itemDetails`.
            - Gọi phương thức `GetListProductById` để lấy thông tin chi tiết của các sản phẩm từ cơ sở dữ liệu (xem thêm chi tiết tại [GetListProductById.md](../GetListProductById.md)).

            ### 2. Xác thực sản phẩm
            - Gọi `StockTakeValidate.ValidateProductNotExistInDb` để kiểm tra tất cả sản phẩm trong `itemDetails` tồn tại trong cơ sở dữ liệu (xem thêm chi tiết tại [ValidateProductNotExistInDb.md](Logic/StockTake/ValidateProductNotExistInDb.md)).

            ### 3. Cập nhật thông tin sản phẩm từ cơ sở dữ liệu
            - Gọi `StockTakeNormalize.UpdateProductInfoFromDb` để cập nhật các thông tin của sản phẩm như (xem thêm chi tiết tại [UpdateProductInfoFromDb.md](Logic/StockTake/UpdateProductInfoFromDb.md)):
            - Giá trị chuyển đổi đơn vị (`ConversionValue`)
            - ID đơn vị chính (`MasterUnitId`)
            - Cờ quản lý lô hàng và hạn sử dụng (`IsBatchExpireControl`)
            - Cờ quản lý số serial (`IsLotSerialControl`)
            - Mã sản phẩm (`ProductCode`) nếu chưa có
            ```
            - This is an example of the GetListProductById method:
            ```
            # Truy vấn thông tin sản phẩm trong GetListProductById

            ## Mục đích
            Phương thức `GetListProductById` trong lớp `StockTakeService` có nhiệm vụ truy vấn và lấy thông tin chi tiết của nhiều sản phẩm từ cơ sở dữ liệu dựa trên danh sách ID sản phẩm được cung cấp. Phương thức này xử lý việc truy vấn một cách hiệu quả, đặc biệt khi đối mặt với danh sách ID sản phẩm lớn.

            ## Quy trình chính

            ### 1. Khởi tạo danh sách kết quả
            - Tạo một danh sách rỗng để lưu trữ thông tin sản phẩm được truy vấn:
            var lsProductStockStakeInfo = new List<ProductStockStakeInfo>();

            ### 2. Xử lý danh sách ID lớn
            - Kiểm tra số lượng ID sản phẩm và chia thành các nhóm nhỏ hơn nếu cần thiết:
            if (lstProductId.Count > SqlExceptionHelper.MaxIdParamsIQueryableExtensions)
            {
                ...
            }

            ### 3. Truy vấn tuần tự từng nhóm ID sản phẩm
            ```