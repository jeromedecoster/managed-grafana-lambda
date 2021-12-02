exports.handler = async (event) => {
    
    var response
    
    //return buildResponse(200, event)
    
    const method = event.requestContext.http.method
    const path = event.requestContext.http.path
    console.log(`method:${method} path:${path} body:${event.body}`)

    if (method == 'GET' && path == '/') {
        response = buildResponse(200, {method, path})
    } else if (method == 'POST' && path == '/api/delay') {
        const { success, delay } = JSON.parse(event.body)
        response = await timeout(success, delay)
    } else {
        response = buildResponse(200, 'nothing')
    }

    return response
}

async function buildResponse(statusCode, body) {
    return {
        statusCode,
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(body)
    }
}

async function timeout(success, time) {
    return new Promise(function(resolve, reject) {
        setTimeout(function() {
            if (success === false) resolve(buildResponse(400, `error ${success} ${time}`))
            else resolve(buildResponse(200, `ok ${success} ${time}`))
        }, time)
    })
}