#!/usr/bin/env node
// https://www.radioreference.com/apps/db/?sid=9380
const list = "422.6625 422.6875 412.9625 423.6125 422.8000 423.5375 412.0625 423.2875 412.1125 423.3625 423.4625 413.1875 423.2625 412.6125 423.3125 423.7375 412.0375 423.3375 423.4375 412.2125"
const arr = list.split(' ').map(a => parseFloat(a, 10) * 10000) // Multiply by 10000 to get around funny numbers
arr.sort((a, b) => a - b)
console.log(
    arr.map((a) => {
        return `${a / 10000}-${(a + 1) / 10000}/1`
    }).join(';')
)