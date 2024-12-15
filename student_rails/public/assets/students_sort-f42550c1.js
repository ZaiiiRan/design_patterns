function toggleSortDirection(column) {
    const urlParams = new URLSearchParams(window.location.search);
    const currentSortColumn = urlParams.get('sort_column');
    const currentSortDirection = urlParams.get('sort_order');

    if (currentSortColumn === column) {
        urlParams.set('sort_order', currentSortDirection === 'asc' ? 'desc' : 'asc');
    } else {
        urlParams.set('sort_column', column);
        urlParams.set('sort_order', 'asc');
    }

    window.location.search = urlParams.toString();
}

document.querySelectorAll('.sortable').forEach(element => {
    element.addEventListener('click', function(event) {
        event.preventDefault();
        toggleSortDirection(this.dataset.column);
    });
});