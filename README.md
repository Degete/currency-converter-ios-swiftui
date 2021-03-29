<p align="center">
    <img src="https://github.com/degete/currency-converter-ios-swiftui/blob/main/dashboard.png?raw=true" height="350px"/>
</p>

# Currency converter

App to exchange rates for any given currency.

## Rate convertion

It uses the [CurrencyLayer](https://currencylayer.com/documentation) API for fetching the rates as well the [currencies list](https://currencylayer.com/currencies).

### API Access Key

In order to make the app to work and fetch the data, the access token has to be set on the build settings:

```
CURRENCY_LAYER_ACCESS_KEY   <access_key>
```

## UI

The development has been done entirely in SwiftUI.

## Dependencies

The project is written entitrely using Swift, without any 3rd party dependency.
