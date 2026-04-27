# Oracle Budget Check

通过 GitHub Action 自动查询甲骨文云账单，发现异常时通过 Telegram 发送通知。

## 功能说明

- 每天北京时间 07:00-22:00 每 3 小时自动查询昨日整天账单
- 账单超过 $0.00 时发送 Telegram 通知
- 支持手动触发测试（默认发送通知）

## GitHub Secrets 配置

在仓库 `Settings > Secrets and variables > Actions` 中添加以下 Secrets：

| Secret Name | 说明 |
|-------------|------|
| `OCI_CONFIG` | 甲骨文配置文件内容 |
| `OCI_PRIVATE_KEY` | 甲骨文 API 私钥内容 |
| `TELEGRAM_BOT_TOKEN` | Telegram Bot Token |
| `TELEGRAM_CHAT_ID` | Telegram Chat ID |

### OCI_CONFIG 格式

```ini
[DEFAULT]
user=ocid1.user.oc1..<your_user_ocid>
fingerprint=<your_fingerprint>
tenancy=ocid1.tenancy.oc1..<your_tenancy_ocid>
region=<your_region>
key_file=~/.oci/oci_key
```

## 运行时间

北京时间 07:00-22:00 每 3 小时运行一次（查询昨日整天账单）。

| GitHub Action (UTC) | 北京时间 (UTC+8) |
|---------------------|------------------|
| 23:00 (前一天) | 07:00 |
| 02:00 | 10:00 |
| 05:00 | 13:00 |
| 08:00 | 16:00 |
| 11:00 | 19:00 |
| 14:00 | 22:00 |

**Cron 表达式**: `0 23,2,5,8,11,14 * * *`

## 手动测试

1. 进入仓库 **Actions** 页面
2. 选择 **Oracle Budget Check**
3. 点击 **Run workflow**
4. 默认勾选 "Force send Telegram notification"

## Telegram 通知示例

```
Daily Budget Report
Date: 2026-04-27
Budget: 0.42 SGD
```
