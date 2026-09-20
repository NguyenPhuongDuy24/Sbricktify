# Sbricktify for TrimUI Brick Pro

An unofficial, experimental Spotify Connect receiver and controller for TrimUI Brick Pro.

## Tiếng Việt

### Trạng thái hỗ trợ

Sbricktify hiện chỉ được thử nghiệm trên **TrimUI Brick Pro chạy StockOS**. Các firmware tuỳ biến, thiết bị TrimUI khác và Linux khác chưa được kiểm tra.

Trong danh sách Spotify Connect, Brick xuất hiện với tên **TrimUI Brick Speaker**. Đây là tên thiết bị phát; tên ứng dụng trong menu TrimUI vẫn là **Sbricktify**.

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

## English

### Support status

Sbricktify has currently been tested only on **TrimUI Brick Pro running StockOS**. Custom firmware, other TrimUI devices, and other Linux systems are not tested.

The Brick appears in Spotify Connect as **TrimUI Brick Speaker**. This is the playback-device name; the TrimUI Apps menu label remains **Sbricktify**.

### Installation

1. Power off the TrimUI and use an SD-card reader.
2. Copy `Apps/Sbricktify` into the `Apps` folder at the SD-card root.
3. Safely eject the card, return it to the Brick, power on, and open **Sbricktify** from Apps.
4. Connect the Brick and phone to the same Wi-Fi network. Guest networks that isolate devices will not work.

### Sign in to Spotify

1. Open Sbricktify and wait for the QR code and six-digit PIN.
2. Scan the QR code with the phone, or enter the address shown on the Brick in the phone browser.
3. Enter the PIN and select **Sign in with Spotify**.
4. The next page opens Spotify automatically. If it remains visible, select **Continue to Spotify**; do not reload the pairing page.
5. After approval, the browser opens `http://127.0.0.1:8989/login`. That page can show an error because `127.0.0.1` refers to the phone.
6. Copy the complete URL from the browser address bar, return to the pairing page, enter the PIN again, paste the URL, and select **Confirm callback**.

### Select the playback device on the phone

1. Open Spotify on the phone and start any track.
2. Open **Devices / Connect to a device**.
3. Select **TrimUI Brick Speaker**.
4. Wait a few seconds for the receiver on the Brick to connect; audio should then play from the Brick.

### Controls on the Brick

- The analog stick moves the cursor; A clicks, or hold A while moving to drag.
- The D-pad scrolls the list below the cursor.
- X toggles play/pause; L and R select the previous and next track.
- B goes back or exits the app, depending on the current screen.
