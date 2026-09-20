# Sbricktify for TrimUI Brick Pro

An unofficial, experimental Spotify Connect receiver and controller for TrimUI Brick Pro.

### Trạng thái hỗ trợ

Sbricktify hiện chỉ được thử nghiệm trên **TrimUI Brick Pro chạy StockOS**. Các firmware tuỳ biến, thiết bị TrimUI khác chưa được kiểm tra.

### Cài đặt

1. Tắt TrimUI và dùng đầu đọc thẻ SD.
2. Chép thư mục `Apps/Sbricktify` vào thư mục `Apps` ở gốc thẻ SD.
3. Eject thẻ an toàn, lắp lại vào Brick, bật máy và mở **Sbricktify** từ Apps.
4. Kết nối Brick và điện thoại vào cùng một mạng Wi-Fi. Mạng guest chặn các thiết bị thấy nhau sẽ không hoạt động.

### Đăng nhập Spotify

1. Mở Sbricktify và chờ QR code cùng mã PIN sáu chữ số xuất hiện.
2. Quét QR bằng điện thoại, hoặc nhập địa chỉ hiển thị trên Brick vào trình duyệt điện thoại.
3. Nhập PIN và chọn **Sign in with Spotify**.
4. Trang tiếp theo sẽ tự mở Spotify. Nếu vẫn đứng ở trang đó, chọn **Continue to Spotify**; không cần reload trang pairing.
5. Sau khi chấp thuận trong Spotify, trình duyệt sẽ mở địa chỉ `http://127.0.0.1:8989/login`. Trang này có thể báo lỗi vì `127.0.0.1` là điện thoại.
6. Sao chép toàn bộ URL trên thanh địa chỉ, quay lại trang pairing, nhập lại PIN, dán URL và chọn **Confirm callback**.

### Khắc phục lỗi trang đăng nhập QR

Nếu sau khi quét QR, trang đăng nhập trên điện thoại hiển thị:

> Request rejected
> Sbricktify could not read that pairing request.
(sau khi hoàn thành mục 1 và 2 trên web hay gặp trường hợp lỗi này)

Hãy thử tải lại (Reload/Refresh) trang pairing vài lần cho đến khi giao diện đăng nhập hiển thị đầy đủ:

**Lưu ý:**
- Chỉ tải lại trang pairing trên Brick (`192.168.x.x:port/...`), không tải lại trang callback `127.0.0.1` của Spotify.
- Nếu vẫn gặp lỗi sau vài lần tải lại, quay về Brick, tạo phiên QR mới rồi quét lại.
- Đảm bảo điện thoại và Brick vẫn kết nối cùng mạng Wi-Fi.

### Chọn thiết bị phát trên điện thoại

1. Mở Spotify trên điện thoại và bắt đầu phát một bài hát.
2. Mở menu **Devices / Connect to a device**.
3. Chọn **TrimUI Brick Speaker**.
4. Chờ vài giây để receiver trên Brick hoàn tất kết nối, rồi âm thanh sẽ phát từ Brick.

### Điều khiển trên Brick

- Analog di chuyển con trỏ; A click hoặc giữ A để kéo.
- D-pad cuộn danh sách dưới con trỏ.
- X phát/tạm dừng; L và R chuyển bài trước/sau.
- B quay lại hoặc thoát ứng dụng theo màn hình hiện tại.
