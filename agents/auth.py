import requests

from . import config


def authenticate_user(
    api_url: str | None = None,
    username: str | None = None,
    password: str | None = None,
    authenticator: str | None = None,
) -> str:
    """使用 NocoBase API 进行登录并返回 Token。

    参数
    ----------
    api_url: str
        NocoBase API 的基础地址，例如 http://localhost:13000/api
    username: str
        用户邮箱地址
    password: str
        用户密码
    authenticator: str, optional
        认证器名称，默认为 ``"local"``

    返回
    -------
    str
        登录成功后获取的 Token

    异常
    ------
    requests.RequestException
        认证请求失败时抛出
    KeyError
        响应中缺少 Token 时抛出
    """
    if api_url is None:
        api_url = config.API_URL
    if username is None:
        username = config.USERNAME
    if password is None:
        password = config.PASSWORD
    if authenticator is None:
        authenticator = config.AUTHENTICATOR

    url = f"{api_url}/auth:signIn"
    headers = {
        "Content-Type": "application/json",
        "X-Authenticator": authenticator,
    }
    data = {"email": username, "password": password}

    try:
        response = requests.post(url, json=data, headers=headers)
        response.raise_for_status()
        return response.json()["data"]["token"]
    except (requests.RequestException, KeyError) as exc:
        raise RuntimeError(f"Authentication failed: {exc}") from exc

