function liveReloadSync() {
    window
        .fetch("http://localhost:8081")
        .then(function (response) {
            if (response.ok && response.status === 200) {
                window.location.reload();
            }
        });
}

function liveReload(interval) {
    setInterval(liveReloadSync, interval ?? 1000);
}