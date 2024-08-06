document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', async function() {
            const username = this.getAttribute('data-username');
            console.log("Attempting to delete user with username:", username);

            try {
                const response = await fetch('/admin/deleteuser', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username: username })
                });

                if (response.ok) {
                    const data = await response.json();
                    const row = document.getElementById(`user-${username}`);
                    if (row) {
                        row.remove();
                    }
                    alert(data.message);
                } else {
                    const error = await response.json();
                    alert(error.message);
                }
            } catch (error) {
                alert('Error deleting user');
                console.error("Error deleting user:", error);
            }
        });
    });
});
