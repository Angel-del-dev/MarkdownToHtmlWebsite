const parse_data = async () => {
    const data = await fetch('/route', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: JSON.stringify({ route: location.pathname })
    })
    .then(r => r.json())
    .then(r => r);
    console.log(data);
};

const main = async () => {
    // load the menu
    // parse data
    parse_data();
};


main();