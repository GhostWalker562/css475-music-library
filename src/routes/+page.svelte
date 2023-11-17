<script lang="ts">
	import { enhance } from '$app/forms';
</script>

<h1 class="my-4 font-semibold">Logged in!</h1>

<form action="?/logout" method="post" use:enhance>
	<button class="btn btn-error" type="submit">Logout</button>
</form>
