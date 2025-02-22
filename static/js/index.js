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
    const container = document.getElementById('menu_list');
    data.menu.map(link => {
        const li = document.createElement('li');
        const a = document.createElement('a');

        let label = link.split('/');
        label = label.pop().split('.')[0];

        a.append(document.createTextNode(label));
        a.setAttribute('href', link);
        li.append(a);
        container.append(li);
    });

    const article = document.querySelector('article');
    article.innerHTML = data.page;
};

const main = async () => {
    // parse data
    parse_data();
};

main();